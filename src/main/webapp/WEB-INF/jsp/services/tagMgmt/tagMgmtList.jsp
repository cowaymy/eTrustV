<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">

var gridID;
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
                       }
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
                          };  
                          
                          gridID = GridCommon.createAUIGrid("tagMgmt_grid_wap", columnLayout  ,"" ,gridPros);
                          
                           

    }
$(document).ready(function(){
	
	tagMgmtGrid(); // tagMgmt 그리드 생성 함수
	
	   //search
    $("#search").click(function() {
                                        
        Common.ajax("GET","/services/tagMgmt/selectTagStatus",$("#tagMgmtForm").serialize(),function(result) {
            console.log("성공.");
            console.log("data : "+ result);
            AUIGrid.setGridData(gridID,result);
        });
                                    
    });
	
    //excel Download
    $('#excelDown').click(function() {
        GridCommon.exportTo("tagMgmt_grid_wap", 'xlsx',"Tag Management");
    });
    
    // cell click
         AUIGrid.bind(gridID, "cellClick", function(event) {
        	 counselingId = AUIGrid.getCellValue(gridID, event.rowIndex, "counselingNo");
        	 console.log(counselingId);
         });
});



function fn_tagLog() {

    var selectedItems = AUIGrid.getSelectedItems(gridID);
    if(selectedItems.length  <= 0) {
        Common.alert("<b>No HS selected.</b>");
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
    <li><p class="btn_blue"><a href="javascript:fn_tagLog()" >View Respond Ticket</a></p></li>
    <li><p class="btn_blue"><a href="#" id ="search"><span class="search"></span>Search</a></p></li>
 
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
    <td><input type="text" id="main_inquiry" name="main_inquiry" title="" placeholder="main_inquiry" class="w100p" /></td>
    <th scope="row">Sub Inquiry</th>
    <td><input type="text" id="sub_inquiry" name="sub_inquiry" title="" placeholder="sub_inquiry" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">Customer</th>
    <td><input type="text" id="customer" name="customer" placeholder="customer" class="w100p" /></td>
    <th scope="row">Main Dept</th>
    <td><input type="text" id="main_department" name="main_department" title="" placeholder="main_department" class="w100p" /></td>
    <th scope="row">Sub Dept</th>
    <td><input type="text" id="" name="sub_department" title="sub_department" placeholder="sub_department" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">Feedback Code</th>
    <td><input type="text" id="feedback_code" name="feedback_code" title="" placeholder="feedback_code" class="w100p" /></td>
   <!--  <th scope="row">Status</th>
    <td>
         <select class="w100p"  id="status" name="status">
            <option value="">Choose One</option>
            <option value="Active">Active</option>
            <option value="Complete">Complete</option>
        </select> -->
    
    
       <th scope="row">Regist Date</th>
    <td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" id="regDt" name="regDt"/></td>
    
</tr>

</tbody>
</table><!-- table end -->


</form>
</section><!-- search_table end -->


<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#" id="excelDown">EXCEL DW</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start  그리드 영역-->
    <div id="tagMgmt_grid_wap" style="width:100%; height:300px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->

