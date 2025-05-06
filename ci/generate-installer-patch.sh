TEMPLATE_FILE="templates/phpw"

echo "diff --git a/phpw b/phpw"
echo "new file mode 100755"
echo "--- /dev/null"
echo "+++ ./phpw"
echo "@@ -0,0 +1,$(cat "$TEMPLATE_FILE" | wc -l | xargs) @@"
cat "$TEMPLATE_FILE" | while IFS= read -r line; do echo "+${line}"; done
