<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>

<script type="text/javaScript" language="javascript">
var myGridIDExcel;

var excelLayout = [
	{dataField:"year" ,headerText:"Year ",width:200 ,height:30},
	{dataField:"month" ,headerText:"Month ",width:120 ,height:30},
	{dataField:"weeks" ,headerText:"Weeks ",width:120 ,height:30},
	{dataField:"keyInStartDate" ,headerText:"Key_In_Start_Date ",width:120 ,height:30},
	{dataField:"keyInEndDate" ,headerText:"Key_In_End_Date ",width:120 ,height:30}
];

var gridPros = {
        usePaging : true,
        pageRowCount : 10,
        editable : false,
        enterKeyColumnBase : true,
        useContextMenu : true,
        enableFilter : true,
        showStateColumn : true,
        displayTreeOpen : true,
        noDataMessage : "<spring:message code='sys.info.grid.noDataMessage' />",
        groupingMessage : "<spring:message code='sys.info.grid.groupingMessage' />",
        enableSorting : true,
        exportURL : "/common/exportGrid.do"
    };

myGridIDExcelHide = GridCommon.createAUIGrid("grid_wrap_hide", excelLayout ,"", gridPros);

function fn_uploadFile() {

	console.log("Here111")

    var formData = new FormData();
    formData.append("excelFile", $("input[name=uploadfile]")[0].files[0]);

    Common.ajaxFile("/sales/keyInMgmt/excelUpload.do", formData, function (result) {

    	console.log(result);

    	if(result.code == "99"){
            Common.alert(" ExcelUpload "+DEFAULT_DELIMITER + result.message);
         }else{
        	 Common.alert(result.message);
         }
    });
}

// 파일 다운로드는 db 설계에 따른 재 구현이 필요함.  현재는 단순 테스트용입니다.
/* function fn_downFile() {

    var fileName = $("#fileName").val();

    //window.open("<c:url value='/sample/down/excel-xls.do?aaa=" + fileName + "'/>");
    //window.open("<c:url value='/sample/down/excel-xlsx.do?aaa=" + fileName + "'/>");
    window.open("<c:url value='/sample/down/excel-xlsx-streaming.do?fileName=" + fileName + "'/>");
} */

$(document).ready(function(){

	/* $('#excelDown').click(function() {
        var excelProps = {
           fileName     : "KeyInMgmtUploadTemplate",
           exceptColumnFields : AUIGrid.getHiddenColumnDataFields(myGridIDExcelHide)
        };
        AUIGrid.exportToXlsx(myGridIDExcelHide, excelProps);
    }); */
});
</script>

<div id="popup_wrap" class="popup_wrap size_mid"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Upload (Excel Update) </h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->


<ul class="right_btns">
    <li><p class="btn_blue2 big"><a href="${pageContext.request.contextPath}/resources/download/sales/KeyInMgmtUploadTemplate.csv">Template</a></p></li>

    <!-- <li><p class="btn_blue"><a id="excelDown">Template</a></p></li> -->
</ul>


<aside class="title_line"><!-- title_line start -->
<h2>Upload</h2>
</aside><!-- title_line end -->



<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">File</th>
    <td>
	<div class="auto_file"><!-- auto_file start -->
	    <form id="fileUploadForm" method="post" enctype="multipart/form-data" action="">
	        <input title="file add" type="file" id="uploadfile" name="uploadfile">
	        <label><span class="label_text"><a href="#">File</a></span><input class="input_text" type="text" readonly="readonly"></label>
	    </form>
	</div><!-- auto_file end -->
    <p class="btn_sky"><a href="javascript:fn_uploadFile()" >ExcelUpLoad</a></p>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_wrap_hide" style="display: none;"></div>
</article>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->