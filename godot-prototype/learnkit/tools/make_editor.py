#!/usr/bin/env python3
"""Builds learning-editor.html (a page for viewing and changing a learner's record) with the maths curriculum inside.

    python3 learnkit/tools/make_editor.py
"""
import json, os
HERE = os.path.dirname(os.path.abspath(__file__))
cur = json.load(open(os.path.join(HERE, "..", "curriculum", "math.json"), encoding="utf-8"))
tpl = open(os.path.join(HERE, "learning-editor-template.html"), encoding="utf-8").read()
out = tpl.replace("/*CURRICULUM*/", json.dumps(cur, ensure_ascii=False).replace("</", "<\\/"))
# the question texts by id, so the page shows "CON-003 On which continent is Egypt?" (only when the game has them)
qt = {}
qp = os.path.join(HERE, "..", "..", "data", "i18n", "quiz-en.json")
if os.path.exists(qp):
    qt = {k: v.get("q", "") for k, v in json.load(open(qp, encoding="utf-8")).items() if v.get("q")}
out = out.replace("/*QUESTIONS*/{}", json.dumps(qt, ensure_ascii=False).replace("</", "<\\/"))
open(os.path.join(HERE, "learning-editor.html"), "w", encoding="utf-8").write(out)
print("wrote learning-editor.html")
