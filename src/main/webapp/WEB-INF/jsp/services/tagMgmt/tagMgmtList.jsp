<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">

var gridID;
var gridIDExcel;
var counselingId;

function tagMgmtGrid() {

    var columnLayout =[
                       {
                           dataField: "counselingNo",
                           headerText: "CounselingNo",
                           width: "10%"
                       },
                       {
                           dataField: "customerName",
                           headerText: "Customer",
                           width: "13%"
                       },
                       {
                           dataField: "mainInquiry",
                           headerText: "Main Inquiry",
                           width: "12%"
                       },
                       {
                           dataField: "subInquiry",
                           headerText: "Sub Inquiry",
                           style: "aui-grid-user-custom-left ",
                           width: "13%"
                       },
                       {
                           dataField: "feedbackCode",
                           headerText: "Feedback Code",
                           width: "10%"
                       },
                       {
                           dataField: "mainDept",
                           headerText: "Main Department",
                           style: "aui-grid-user-custom-left ",
                           width: "13%"
                       },
                       {
                           dataField: "subDept",
                           headerText: "Sub Department",
                           style: "aui-grid-user-custom-left ",
                           width: "15%"
                       },
                       {
                           dataField: "regDate",
                           headerText: "Register Date",
                           dataType : "date"
                       },
                       {
                           dataField: "status",
                           headerText: "Status",
                           width: "5%"
                       }
                   ];

    var excelLayout = [
                        {dataField: "regDate",headerText: "Register Date",width:150 ,height:80}
                       ,{dataField: "counselingNo",headerText: "CounselingNo",width:200 ,height:80}
                       ,{dataField: "customerName",headerText: "Customer",width:200 ,height:80}
                       ,{dataField: "mainInquiry",headerText: "Main Inquiry",width:200 ,height:80}
                       ,{dataField: "subInquiry",headerText: "Sub Inquiry",width:200 ,height:80}
                       ,{dataField: "mainDept",headerText: "Main Department",width:200 ,height:80}
                       ,{dataField: "subDept",headerText: "Sub Department",width:200 ,height:80}
                       ,{dataField: "updDt",headerText: "Update Date",width:150 ,height:80}
                       ,{dataField: "lstUpdId",headerText: "Updated By",width:150 ,height:80}
                       ,{dataField: "status",headerText: "Status",width:100 ,height:80}
                       ,{dataField: "callRem",headerText: "Remark",width:500 ,height:80}
                       ];

     var gridPros = {
    		                        usePaging           : true,         //페이징 사용
                        	        pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)
                        	        showStateColumn     : false,
                        	        displayTreeOpen     : false,
                        	        selectionMode       : "singleRow",  //"multipleCells",
                        	        skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
                        	        wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
                        	        showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력
                        	        editable :false
                          };

     var excelGridPros = {
             enterKeyColumnBase : true,
             useContextMenu : true,
             enableFilter : true,
             showStateColumn : true,
             displayTreeOpen : true,
             wordWrap : true,
             noDataMessage : "<spring:message code='sys.info.grid.noDataMessage' />",
             groupingMessage : "<spring:message code='sys.info.grid.groupingMessage' />",
             exportURL : "/common/exportGrid.do"
         };

                          gridID = GridCommon.createAUIGrid("tagMgmt_grid_wap", columnLayout  ,"" ,gridPros);
                          gridIDExcelHide = GridCommon.createAUIGrid("grid_wrap_hide", excelLayout  ,"" ,excelGridPros);



    }
$(document).ready(function(){

	tagMgmtGrid(); // tagMgmt 그리드 생성 함수

	   //search
    $("#search").click(function() {

        Common.ajax("GET","/services/tagMgmt/selectTagStatus",$("#tagMgmtForm").serialize(),function(result) {
            AUIGrid.setGridData(gridID,result);
            AUIGrid.setGridData(gridIDExcelHide,result);
        });

    });

    //excel Download
    $('#excelDown').click(function() {
        //GridCommon.exportTo("tagMgmt_grid_wap", 'xlsx',"Tag Management");
        var excelProps = {
            fileName     : "Tag Management",
           exceptColumnFields : AUIGrid.getHiddenColumnDataFields(gridIDExcelHide)
        };
        AUIGrid.exportToXlsx(gridIDExcelHide, excelProps);
    });

    // cell click
         AUIGrid.bind(gridID, "cellClick", function(event) {
        	 counselingId = AUIGrid.getCellValue(gridID, event.rowIndex, "counselingNo");

         });


         doGetCombo('/services/tagMgmt/selectMainDept.do', '' , '', 'main_department' , 'S', '');


         $("#main_department").change(function(){
           if($("#main_department").val() == ''){
        	   $("#sub_department").val('');
        	   $("#sub_department").find("option").remove();
           }else{
        	    doGetCombo('/services/tagMgmt/selectSubDept.do',  $("#main_department").val(), '','sub_department', 'S' ,  '');
           }
       });


         doGetCombo('/services/tagMgmt/selectMainInquiry.do', '' , '', 'main_inquiry' , 'S', '');


         $("#main_inquiry").change(function(){

           doGetCombo('/services/tagMgmt/selectSubInquiry.do',  $("#main_inquiry").val(), '','sub_inquiry', 'S' ,  '');

       });

});



function fn_tagLog() {

    var selectedItems = AUIGrid.getSelectedItems(gridID);
    if(selectedItems.length  <= 0) {
        Common.alert("<b>No Tag selected.</b>");
        return ;
    }




       //Common.popupDiv("/services/tagMgmt/tagLogRegist.do?&salesOrdId="+salesOrdId +"&brnchId="+brnchId, null, null , true , '_ConfigBasicPop');
       Common.popupDiv("/services/tagMgmt/tagLogRegistPop.do?counselingId="+counselingId+"", null, null , true , "tagLogRegistPop");

}



</script>




<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/images/common/path_home.gif" alt="Home" /></li>
    <li>Service</li>
    <li>Tag Mgmt</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Tag Log Search</h2>
<ul class="right_btns">
<c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
    <li><p class="btn_blue"><a href="javascript:fn_tagLog()" >View Respond Ticket</a></p></li>
</c:if>
<c:if test="${PAGE_AUTH.funcView == 'Y'}">
    <li><p class="btn_blue"><a href="#" id ="search"><span class="search"></span>Search</a></p></li>
</c:if>
<!--     <li><p class="btn_blue"><a href="#" onclick="javascript:fn_Clear()"><span class="clear"></span>Clear</a></p></li> -->
</ul>


</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form id="tagMgmtForm" name="tagMgmtForm" method="post">




<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Counselling No</th>
    <td><input type="text" id="customer" name="counseling_no" placeholder="counseling_no" class="w100p" /></td>
    <th scope="row">Main Inquiry</th>
    <td><select class="w100p" id="main_inquiry" name="main_inquiry"></select></td>
    <th scope="row">Sub Inquiry</th>
    <td><select class="w100p" id="sub_inquiry" name="sub_inquiry"></select></td>
</tr>
<tr>
    <th scope="row">Customer</th>
    <td><input type="text" id="customer" name="customer" placeholder="customer" class="w100p" /></td>
    <th scope="row">Main Dept</th>
    <td><select class="w100p" id="main_department" name="main_department"></select></td>
    <th scope="row">Sub Dept</th>
    <td><select class="w100p" id="sub_department" name="sub_department"></select></td>
</tr>
<tr>
    <th scope="row">Feedback Code</th>
    <td><input type="text" id="feedback_code" name="feedback_code" title="" placeholder="feedback_code" class="w100p" /></td>




       <th scope="row">Regist Date</th>
       <td>
       <div class="date_set w100p"><!-- date_set start -->
        <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" id="regStartDt" name="regStartDt"/></p>
        <span>To</span>
        <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date w100p" id="regEndDt" name="regEndDt"/></p>
       </div><!-- date_set end -->
       </td>

     <th scope="row">Status</th>
    <td>
         <select  class="multy_select w100p" multiple="multiple"  id="statusList" name="statusList">
                 <option value="1">Active</option>
                <option value="44">Pending</option>
                <option value="34">Solved</option>
                <option value="35">Unsolved</option>
                <option value="36">Closed</option>
                <option value="10">Cancelled</option>
        </select>
    </td>

</tr>

</tbody>
</table><!-- table end -->


</form>
</section><!-- search_table end -->


<section class="search_result"><!-- search_result start -->
<c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
<ul class="right_btns">
    <li><p class="btn_grid"><a href="#" id="excelDown">GENERATE</a></p></li>
</ul>
</c:if>
<article class="grid_wrap"><!-- grid_wrap start  그리드 영역-->
    <div id="tagMgmt_grid_wap" style="width:100%; height:300px; margin:0 auto;"></div>
    <div id="grid_wrap_hide" style="display: none;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->

