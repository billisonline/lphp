TEMPLATE_FILE="templates/vphp"

echo "diff --git a/vphp b/vphp"
echo "new file mode 100755"
echo "--- /dev/null"
echo "+++ ./vphp"
echo "@@ -0,0 +1,$(cat "$TEMPLATE_FILE" | wc -l | xargs) @@"
cat "$TEMPLATE_FILE" | while IFS= read -r line; do echo "+${line}"; done
