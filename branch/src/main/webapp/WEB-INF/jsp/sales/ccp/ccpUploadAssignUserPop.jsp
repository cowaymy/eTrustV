<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<style type="text/css">
/* 커스텀 행 스타일 */
.my-row-style {
    background:#9FC93C;
    font-weight:bold;
    color:#22741C;
}
</style>
<script type="text/javascript" language="javascript">

var myGridID;

$(document).ready(function(){
	createTempGrid();
});

function createTempGrid() {

	var templateLayout = [
                         {dataField : "no", headerText : "no", width : 130, visible: true},
	                     {dataField : "orderNo", headerText : "OrderNo", width : 130, visible: true},
	                     {dataField : "username", headerText : "Assign User Name", width : 130, visible: true},
	                     {dataField : "remarks", headerText : "Remarks", width : 300, visible: true}
	                    ];

	var gridPros = {
            usePaging : true,
               // 한 화면에 출력되는 행 개수 20(기본값:20)
               pageRowCount : 20,
               editable : true,
               fixedColumnCount : 1,
               showStateColumn : false,
               displayTreeOpen : true,
               selectionMode : "multipleCells",
               headerHeight : 30,
               // 그룹핑 패널 사용
               useGroupingPanel : false,
               // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
               skipReadonlyColumns : true,
               // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
               wrapSelectionMove : true,
               // 줄번호 칼럼 렌더러 출력
               showRowNumColumn : false,

               groupingMessage : "Here groupping"
       };

	myGridID = AUIGrid.create("#list_grid_wrap", templateLayout, gridPros);

}

$(function(){
	$("#template").click(function() {
	    GridCommon.exportTo("list_grid_wrap", "csv", "CCP Upload Assign User");
	});
});

function fn_uploadFile() {
	if($("#uploadfile").val() == null || $("#uploadfile").val() == ""){
        Common.alert("File not found. Please upload the file.");
    } else {

  	var fileInput = document.querySelector('input[name=uploadfile]');
  	var path = fileInput.value;
  	var fileName = path.split(/(\\|\/)/g).pop();
  	console.log('File name:', fileName);

    var formData = new FormData();
    //formData.append("excelFile", $("input[name=uploadfile]")[0].files[0]);
    formData.append("csvFile", $("input[name=uploadfile]")[0].files[0]);
    formData.append("filename", fileName);

    Common.ajaxFile("/sales/ccp/ccpCsvUpload.do", formData, function (result) {

        console.log(result);
        Common.alert(result.message);

        fn_closePop();

    });
    }
}

function fn_closePop() {
    $("#ccpUploadAssignUserClose").click();
}
</script>

<div id="popup_wrap" class="popup_wrap size_mid"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>CCP Daily Assignment Batch Upload</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a id="ccpUploadAssignUserClose" href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->
<h2>CCP Assign User File Upload</h2>
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
                <label><span class="label_text"><a id = "txtFileInput" href="#">File</a></span><input class="input_text" type="text" readonly="readonly"></label>
           </form>
        </div><!-- auto_file end -->
    </td>
</tr>
<tr>
    <th scope="row" colspan="6" ><span class="must">* Only accept CSV format. Max file size only 20MB. </span> </th>
</tr>
</tbody>
</table> <!-- table end -->

<ul class="center_btns mt20">
    <li><p class="btn_blue2 big"><a href="javascript:fn_uploadFile();"><spring:message code='pay.btn.uploadFile'/></a></p></li>
    <li><p class="btn_blue2 big"><a id="template">Template Download</a></p></li>
</ul>

<input type="hidden" id="list_grid_wrap"/>

</section><!-- pop_body end -->

</div> <!-- popup_wrap end -->

