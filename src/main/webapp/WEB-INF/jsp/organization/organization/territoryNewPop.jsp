
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>



<script type="text/javaScript" language="javascript">
var myGridIDExcel;

var excelLayout = [
                   {dataField:"areaId" ,headerText:"Area_ID ",width:200 ,height:30},
                   {dataField:"branch" ,headerText:"Branch ",width:120 ,height:30},
                   {dataField:"extBranch" ,headerText:"EXT_Branch ",width:120 ,height:30}
                   ];
var gridPros = {
        // 페이지 설정
        usePaging : true,
        pageRowCount : 10,
        //fixedColumnCount : 1,
        // 편집 가능 여부 (기본값 : false)
        editable : false,
        // 엔터키가 다음 행이 아닌 다음 칼럼으로 이동할지 여부 (기본값 : false)
        enterKeyColumnBase : true,
        // 셀 선택모드 (기본값: singleCell)
        //selectionMode : "multipleCells",
        // 컨텍스트 메뉴 사용 여부 (기본값 : false)
        useContextMenu : true,
        // 필터 사용 여부 (기본값 : false)
        enableFilter : true,
        // 그룹핑 패널 사용
        //useGroupingPanel : true,
        // 상태 칼럼 사용
        showStateColumn : true,
        // 그룹핑 또는 트리로 만들었을 때 펼쳐지게 할지 여부 (기본값 : false)
        displayTreeOpen : true,
        noDataMessage : "<spring:message code='sys.info.grid.noDataMessage' />",
        groupingMessage : "<spring:message code='sys.info.grid.groupingMessage' />",
        //selectionMode : "multipleCells",
        //rowIdField : "stkid",
        enableSorting : true,
        //showRowCheckColumn : true,
        exportURL : "/common/exportGrid.do"
    };

myGridIDExcelHide = GridCommon.createAUIGrid("grid_wrap_hide", excelLayout ,"", gridPros);



function fn_uploadFile() {

    var formData = new FormData();
    formData.append("excelFile", $("input[name=uploadfile]")[0].files[0]);
    formData.append("comBranchTypep", $("#comBranchTypep").val());

    Common.ajaxFile("/organization/territory/excelUpload", formData, function (result) {

    	console.log(result);

    	if(result.code == "99"){
            Common.alert(" ExcelUpload "+DEFAULT_DELIMITER + result.message);
         }else{
        	 Common.alert(result.message);
         }
    });
}



// 파일 다운로드는 db 설계에 따른 재 구현이 필요함.  현재는 단순 테스트용입니다.
function fn_downFile() {

    var fileName = $("#fileName").val();

    //window.open("<c:url value='/sample/down/excel-xls.do?aaa=" + fileName + "'/>");
    //window.open("<c:url value='/sample/down/excel-xlsx.do?aaa=" + fileName + "'/>");
    window.open("<c:url value='/sample/down/excel-xlsx-streaming.do?fileName=" + fileName + "'/>");
}



$(document).ready(function(){
	var stringMemType ="${param.memType}";
	$("#comBranchTypep").val(stringMemType);

	$('#excelDown').click(function() {
        // 그리드의 숨겨진 칼럼이 있는 경우, 내보내기 하면 엑셀에 아예 포함시키지 않습니다.
        // 다음처럼 excelProps 에서 exceptColumnFields 을 지정하십시오.

        var excelProps = {

            fileName     : "Assign Change Upload",
            //sheetName : $("#txtlocCode").text(),

            //exceptColumnFields : ["cntQty"], // 이름, 제품, 컬러는 아예 엑셀로 내보내기 안하기.

             //현재 그리드의 히든 처리된 칼럼의 dataField 들 얻어 똑같이 동기화 시키기
           exceptColumnFields : AUIGrid.getHiddenColumnDataFields(myGridIDExcelHide)
        };

        //AUIGrid.exportToXlsx(myGridIDHide, excelProps);
        AUIGrid.exportToXlsx(myGridIDExcelHide, excelProps);
        //GridCommon.exportTo("grid_wrap", "xlsx", "test");
    });



});





</script>



<div id="popup_wrap" class="popup_wrap size_mid"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Upload Assign Change Request (Excel Update) </h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->


<ul class="right_btns">
    <li><p class="btn_blue"><a id="excelDown">Template</a></p></li>
</ul>


<aside class="title_line"><!-- title_line start -->
<h2>Upload Assign Change Request</h2>
</aside><!-- title_line end -->



<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>


    <th scope="row">Branch Type</th>
    <td>
            <select class="multy_select w100p"  id="comBranchTypep" name="comBranchTypep">
               <option value="42">Cody Branch</option>
               <option value="43">Dream Service Center</option>
               <option value="45">Sales Office</option>
            </select>

    </td>
</tr>
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