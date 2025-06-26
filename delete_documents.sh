#!/bin/bash

API_URL="https://api.{region}.commercetools.com/{project-key}/{endpoint}"
AUTH_TOKEN="ADD_YOUR_AUTH_TOKEN_HERE"
LIMIT=100
LAST_ID=""
CONTINUE=true

echo "🚀 Starting deletion of documents..."

while $CONTINUE; do
  if [ -z "$LAST_ID" ]; then
    RESPONSE=$(curl -s -X GET "$API_URL?withTotal=false&limit=$LIMIT&sort=id+asc" \
      -H "Authorization: Bearer $AUTH_TOKEN" \
      -H "Content-Type: application/json" \
      -H "User-Agent: CommercetoolsCleanupScript/1.0")
  else
    RESPONSE=$(curl -s -X GET "$API_URL?withTotal=false&limit=$LIMIT&sort=id+asc&where=id%3E\"$LAST_ID\"" \
      -H "Authorization: Bearer $AUTH_TOKEN" \
      -H "Content-Type: application/json" \
      -H "User-Agent: CommercetoolsCleanupScript/1.0")
  fi

  # Validate JSON
  if ! echo "$RESPONSE" | jq . > /dev/null 2>&1; then
    echo "❌ Invalid JSON response:"
    echo "$RESPONSE"
    exit 1
  fi

  COUNT=$(echo "$RESPONSE" | jq '.results | length')

  if ! [[ "$COUNT" =~ ^[0-9]+$ ]]; then
    echo "❌ Failed to extract result count from response."
    echo "Response was: $RESPONSE"
    exit 1
  fi

  if [ "$COUNT" -eq 0 ]; then
    echo "✅ No more documents found. Finished."
    break
  fi

  echo "🔄 Found $COUNT documents. Deleting..."

  LAST_SEEN_ID=""
  echo "$RESPONSE" | jq -c '.results[]' | while IFS= read -r ROW; do
    ID=$(echo "$ROW" | jq -r '.id')
    VERSION=$(echo "$ROW" | jq -r '.version')

    if [ -z "$ID" ] || [ -z "$VERSION" ]; then
      echo "⚠️  Skipping malformed item: $ROW"
      continue
    fi

    DELETE_URL="$API_URL/$ID?version=$VERSION"
    echo "🗑️  Deleting ID: $ID (version $VERSION)"

    curl -s -X DELETE "$DELETE_URL" \
      -H "Authorization: Bearer $AUTH_TOKEN" \
      -H "Content-Type: application/json" \
      -H "User-Agent: CommercetoolsCleanupScript/1.0" > /dev/null

    LAST_SEEN_ID="$ID"
  done

  # Update LAST_ID outside the subshell
  LAST_ID="$LAST_SEEN_ID"

  if [ "$COUNT" -lt "$LIMIT" ]; then
    CONTINUE=false
  fi
done

echo "✅ All deletions complete."
