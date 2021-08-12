<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>


<!--

[전자정부 참고]

- http://www.egovframe.go.kr/wiki/doku.php?id=egovframework:%EC%9B%B9%EC%97%90%EB%94%94%ED%84%B0
- http://localhost:8180/htmlarea3.0/reference.html

[기타 참고]

- http://htmlarea.sourceforge.net/reference.html
- https://www.codeproject.com/Articles/2843/htmlArea-Turn-any-TEXTAREA-into-a-WYSIWYG-editor
-->

<!-- EDITOR -->
<script type="text/javaScript" language="javascript">
    _editor_area = "editorArea";        //  -> 페이지에 웹에디터가 들어갈 위치에 넣은 textarea ID
    _editor_url = "<c:url value='${pageContext.request.contextPath}/resources/htmlarea3.0/'/>";
</script>
<script type="text/javascript" src="<c:url value='${pageContext.request.contextPath}/resources/htmlarea3.0/htmlarea.js'/>"></script>
<!-- EDITOR -->

<script type="text/javaScript" language="javascript">

    $(document).ready(function () {
        fn_initEditor();
    });

    function fn_getEditorText() {
        alert(editor.getHTML());
    }

    /*-- EDITOR --*/
    function fn_saveText() {
        Common.ajax("POST", "/sample/saveEditor.do", {memoCntnt: editor.getHTML()}, function (result) {
            console.log(result.data);
            $("#memoId").val(result.data);
        });
    }

    function fn_selectMemoId(){
        fn_getSampleListAjax();
    }

    function fn_initEditor() {
        HTMLArea.init();
        HTMLArea.onload = initEditor;
    }

    // ajax list 조회.
    function fn_getSampleListAjax() {
        Common.ajax("GET", "/sample/getEditor.do", $("#searchForm").serialize(), function (result) {
            console.log("성공.");
            console.log("data : " + result);

            if (result.length > 0) {

//                $("#editorArea").val("");
                editor.setHTML(""); // 에디터 내용 초기화.
                editor.insertHTML(result[0].memoCntnt);
            }

        });
    }

</script>

<div id="content_pop">
    <!-- 타이틀 -->
    <div id="title">
        <ul>
            <li>editor sample</li>
        </ul>
    </div>

    <form id="searchForm" method="get" action="">
        memoId : <input type="text" id="memoId" name="memoId">
    </form>

    <table>
    <tr>
        <td>
            <!--  Min Width : 615px -->
            <textarea id="editorArea" name="editorArea" cols="75" rows="14" style="width:615px; height:400px"></textarea>
        </td>
    </tr>
    </table>
    <div id="main">
        <div id="divDetail">
            <form id="detailForm" method="post" action="">
                <input type="button" value="fn_getEditorText" onclick="fn_getEditorText();"/>
                <input type="button" value="save" onclick="fn_saveText();"/>
                <input type="button" value="select" onclick="fn_selectMemoId();"/>
            </form>
        </div>
    </div>
</div>
