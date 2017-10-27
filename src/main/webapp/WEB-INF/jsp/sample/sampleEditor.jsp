<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>



<!--

[전자정부 참고]

http://www.egovframe.go.kr/wiki/doku.php?id=egovframework:%EC%9B%B9%EC%97%90%EB%94%94%ED%84%B0

-->

<script type="text/javaScript" language="javascript">
    _editor_area = "editorArea";        //  -> 페이지에 웹에디터가 들어갈 위치에 넣은 textarea ID
    _editor_url = "<c:url value='/resources/htmlarea3.0/'/>";
</script>
<script type="text/javascript" src="<c:url value='/resources/htmlarea3.0/htmlarea.js'/>"></script>


<script type="text/javaScript" language="javascript">

    $(document).ready(function () {
        HTMLArea.init();
        HTMLArea.onload = initEditor;


        $("#editorArea").text("<p>\n" +
            "aaaaaaaaaaaa\n" +
            "</p><p></p><p></p><p><img align=\"baseline\" src=\"/editor/imageSrc.do?path=editor&physical=91F393D48F0549508C52E4CB094E1610&contentType=image/png\" /></p>");
    });


    // ajax list 조회.
    function fn_getSampleListAjax() {
        Common.ajax("GET", "/sample/selectJsonSampleList", $("#searchForm").serialize(), function (result) {
            console.log("성공.");
            console.log("data : " + result);
            AUIGrid.setGridData(myGridID, result);
        });
    }

</script>

<div id="content_pop">
    <!-- 타이틀 -->
    <div id="title">
        <ul>
            <li><img src="<c:url value='/resources/images/egovframework/example/title_dot.gif'/>"
                     alt=""/><spring:message code="list.sample"/></li>
        </ul>
    </div>

    <form id="searchForm" method="get" action="">

    </form>

    <table>
    <tr>
        <th>에디터 샘플......</th>
    </tr>
    <tr>
        <td>
            <!--  Min Width : 615px -->
            <textarea id="editorArea" name="editorArea" cols="75" rows="14" style="width:615px; height:400px"></textarea>
        </td>
    </tr>
    </table>
    <div id="main">

        <div class="desc_bottom">
            <p id="selectionDesc">22</p>
        </div>

        <div id="divDetail">
            <form id="detailForm" method="post" action="">
                id : <input type="text" id="id" name="id" value="tmp1"/><br/>
                name : <input type="text" id="name" name="name" value="tmp2"/><br/>
                description : <input type="text" id="description" name="description" value="tmp3"/><br/>
            </form>
        </div>
    </div>
</div>
