<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">
var option = {
        width : "1200px",   // 창 가로 크기
        height : "500px"    // 창 세로 크기
};


var myGridID;

function fn_searchASManagement(){
        Common.ajax("GET", "/services/as/searchASManagementList.do", $("#ASForm").serialize(), function(result) {
            console.log("성공.");
            console.log("data : " + result);
            AUIGrid.setGridData(myGridID, result);
        });
}

function fn_newASPop(){
	
    Common.popupDiv("/services/as/ASReceiveEntryPop.do" ,null, null , true , '_NewEntryPopDiv1');
    
}


function fn_viewASResultPop(){
	
    
    var selectedItems = AUIGrid.getSelectedItems(myGridID);
	
    if(selectedItems.length  <= 0) {
        Common.alert("<b>No AS selected.</b>");
        return ;
    }
    
    
    var AS_ID =    selectedItems[0].item.asId;
    var AS_NO =    selectedItems[0].item.asNo;
    var asStusId =    selectedItems[0].item.code1;
    var ordno  =selectedItems[0].item.salesOrdNo;
    var ordId  =selectedItems[0].item.asSoId;
    
    if(asStusId  !="ACT"){
          Common.alert( "AS Info Edit Restrict</br>" +DEFAULT_DELIMITER+"<b>[" + AS_NO + "]  is not in active status.</br> AS information edit is disallowed.</b>" );
          return ;
    }
    
	Common.popupDiv("/services/as/resultASReceiveEntryPop.do?mod=VIEW&salesOrderId="+ordId+"&ordNo="+ordno+"&AS_NO="+AS_NO  ,null, null , true , '_viewEntryPopDiv1');
    
}





function fn_resultASPop(ordId,ordNo){
	Common.popupDiv("/services/as/resultASReceiveEntryPop.do?salesOrderId="+ordId+"&ordNo="+ordNo ,null, null , true , '_resultNewEntryPopDiv1');

    
}





function fn_newASResultPop(){
	
    var selectedItems = AUIGrid.getSelectedItems(myGridID);
    
    if(selectedItems.length  <= 0) {
        Common.alert("<b>No AS selected.</b>");
        return ;
    }
    
    var asid =    selectedItems[0].item.asId;
    var asNo =    selectedItems[0].item.asNo;
    var asStusId     = selectedItems[0].item.code1;
    var salesOrdNo  = selectedItems[0].item.salesOrdNo;
    var salesOrdId  =selectedItems[0].item.asSoId;
    
    
    if(asStusId  !="ACT"){
    	  Common.alert("<b>[" + asNo + "] already has [" + asStusId + "] result.  .</br> Result entry is disallowed.</b>");
          return ;
    }
    
    var param = "?ord_Id="+salesOrdId+"&ord_No="+salesOrdNo+"&as_No="+asNo+"&as_Id="+asid;
    Common.popupDiv("/services/as/ASNewResultPop.do"+param ,null, null , true , '_newASResultDiv1');
}




function fn_asAppViewPop(){
    
    var selectedItems = AUIGrid.getSelectedItems(myGridID);
    
    if(selectedItems.length  <= 0) {
        Common.alert("<b>No AS selected.</b>");
        return ;
    }
    

    var asid =    selectedItems[0].item.asId;
    var asNo =    selectedItems[0].item.asNo;
    var asStusId     = selectedItems[0].item.code1;
    var salesOrdNo  = selectedItems[0].item.salesOrdNo;
    var salesOrdId  =selectedItems[0].item.asSoId;
    
    var param = "?ord_Id="+salesOrdId+"&ord_No="+salesOrdNo+"&as_No="+asNo+"&as_Id="+asid;
    Common.popupDiv("/services/as/asResultViewPop.do"+param ,null, null , true , '_newASResultDiv1');
}




function fn_asResultViewPop(){
	
	
    var selectedItems = AUIGrid.getSelectedItems(myGridID);
    
    if(selectedItems.length  <= 0) {
        Common.alert("<b>No AS selected.</b>");
        return ;
    }
    
    
    
    console.log(selectedItems);
    var asid =    selectedItems[0].item.asId;
    var asNo =    selectedItems[0].item.asNo;
    var asStusId     = selectedItems[0].item.code1;
    var salesOrdNo  = selectedItems[0].item.salesOrdNo;
    var salesOrdId  =selectedItems[0].item.asSoId;
    var asResultNo  =selectedItems[0].item.c3;
	   
    if(asStusId  =="ACT"){
        Common.alert("<b>[" + asNo + "] do no has any result yet..</br> Result view is disallowed.");
        return ;
   }
    console.log(selectedItems[0].item);
    
    
  if(asResultNo  ==""){
        Common.alert("<b>[" + asNo + "] do no has any result yet. .</br> Result view is disallowed.");
        return ;
  }
  
  var param = "?ord_Id="+salesOrdId+"&ord_No="+salesOrdNo+"&as_No="+asNo+"&as_Id="+asid+"&mod=view&as_Result_No="+asResultNo;
 
  Common.popupDiv("/services/as/asResultEditViewPop.do"+param ,null, null , true , '_newASResultDiv1');
  
	
}




function fn_asResultEditPop(){

    var selectedItems = AUIGrid.getSelectedItems(myGridID);
    
    if(selectedItems.length  <= 0) {
        Common.alert("<b>No AS selected.</b>");
        return ;
    }
    
    
    
    console.log(selectedItems);
    var asid =    selectedItems[0].item.asId;
    var asNo =    selectedItems[0].item.asNo;
    var asStusId     = selectedItems[0].item.code1;
    var salesOrdNo  = selectedItems[0].item.salesOrdNo;
    var salesOrdId  =selectedItems[0].item.asSoId;
    var asResultNo  =selectedItems[0].item.c3;
    var asResultId  =selectedItems[0].item.asResultId;
    
    if(asStusId  =="ACT"){
        Common.alert("<b>[" + asNo + "] do no has any result yet. .</br> Result view is disallowed.");
        return ;
   }
    console.log(selectedItems[0].item);
    
    
  if(asResultNo  ==""){
        Common.alert("<b>[" + asNo + "] do no has any result yet. .</br> Result view is disallowed.");
        return ;
  }
  
  var param = "?ord_Id="+salesOrdId+"&ord_No="+salesOrdNo+"&as_No="+asNo+"&as_Id="+asid+"&mod=edit&as_Result_No="+asResultNo+"&as_Result_Id="+asResultId;
  Common.popupDiv("/services/as/asResultEditViewPop.do"+param ,null, null , true , '_newASResultDiv1');
    
}



function fn_asResultEditBasicPop(){

    var selectedItems = AUIGrid.getSelectedItems(myGridID);
    
    if(selectedItems.length  <= 0) {
        Common.alert("<b>No AS selected.</b>");
        return ;
    }
    
    
    
    console.log(selectedItems);
    var asid =    selectedItems[0].item.asId;
    var asNo =    selectedItems[0].item.asNo;
    var asStusId     = selectedItems[0].item.code1;
    var salesOrdNo  = selectedItems[0].item.salesOrdNo;
    var salesOrdId  =selectedItems[0].item.asSoId;
    var asResultNo  =selectedItems[0].item.c3;
    var asResultId  =selectedItems[0].item.asResultId;
    
    if(asStusId  =="ACT"){
        Common.alert("<b>[" + asNo + "] do no has any result yet. .</br> Result view is disallowed.");
        return ;
   }
    console.log(selectedItems[0].item);
    
    
  if(asResultNo  ==""){
        Common.alert("<b>[" + asNo + "] do no has any result yet. .</br> Result view is disallowed.");
        return ;
  }
  
  var param = "?ord_Id="+salesOrdId+"&ord_No="+salesOrdNo+"&as_No="+asNo+"&as_Id="+asid+"&mod=edit&as_Result_No="+asResultNo+"&as_Result_Id="+asResultId;
  Common.popupDiv("/services/as/asResultEditBasicPop.do"+param ,null, null , true , '_newASResultBasicDiv1');
    
}



$(document).ready(function() {

    // AUIGrid 그리드를 생성합니다.
    asManagementGrid();
    
    AUIGrid.setSelectionMode(myGridID, "singleRow");
    
/*  // 셀 더블클릭 이벤트 바인딩
      AUIGrid.bind(myGridID, "cellDoubleClick", function(event) {
            //alert(event.rowIndex+ " - double clicked!! : " + event.value + " - rowValue : " + AUIGrid.getCellValue(myGridID, event.rowIndex, "memberid"));
            Common.popupDiv("/organization/selectMemberListDetailPop.do?isPop=true&MemberID=" + AUIGrid.getCellValue(myGridID, event.rowIndex, "memberid")+"&MemberType=" + AUIGrid.getCellValue(myGridID, event.rowIndex, "membertype"), "");
        });
 */
   /*   AUIGrid.bind(myGridID, "cellClick", function(event) {
        //alert(event.rowIndex+ " -cellClick : " + event.value + " - rowValue : " + AUIGrid.getCellValue(myGridID, event.rowIndex, "memberid"));
        callStusCode =  AUIGrid.getCellValue(myGridID, event.rowIndex, "callStusCode");
        callStusId = AUIGrid.getCellValue(myGridID, event.rowIndex, "callStusId");
        salesOrdId = AUIGrid.getCellValue(myGridID, event.rowIndex, "salesOrdId");
        callEntryId = AUIGrid.getCellValue(myGridID, event.rowIndex, "callEntryId");
        //Common.popupDiv("/organization/requestTerminateResign.do?isPop=true&MemberID=" + AUIGrid.getCellValue(myGridID, event.rowIndex, "memberid")+"&MemberType=" + AUIGrid.getCellValue(myGridID, event.rowIndex, "membertype"), "");
        console.log(callStusCode+ "     " + callStusId + "     " + salesOrdId+ "     "  + callEntryId)
    });   */
     
});
function asManagementGrid() {
    //AUIGrid 칼럼 설정
    var columnLayout = [ {
        dataField : "code",
        headerText : "Type",
        editable : false,
        width : 100
    }, {
        dataField : "asNo",
        headerText : "AS No",
        editable : false,
        width : 100
    }, {
        dataField : "asReqstDt",
        headerText : "Reques Date",
        editable : false,
        width : 110 , dataType : "date", formatString : "dd/mm/yyyy"
    }, {
        dataField : "code1",
        headerText : "Status",
        editable : false,
        width : 80
    }, {
        dataField : "c3",
        headerText : "Result No",
        editable : false,
        style : "my-column",
        width : 100
    }, {
        dataField : "c4",
        headerText : "Key By",
        editable : false,
        width : 100
    }, {
        dataField : "salesOrdNo",
        headerText : "Order No",
        editable : false,
        width : 100
        
    }, {
        dataField : "code2",
        headerText : "App Type",
        width : 100
    }, {
        dataField : "name",
        headerText : "Cust Name",
        width : 200
    }, {
        dataField : "nric",
        headerText : "NRIC/Comp No",
        width : 100
    }];
     // 그리드 속성 설정
    var gridPros = {
        
        // 페이징 사용       
        usePaging : true,
        
        // 한 화면에 출력되는 행 개수 20(기본값:20)
        pageRowCount : 20,
        
        editable : true,
        
        showStateColumn : true, 
        
        displayTreeOpen : true,
        
        
        headerHeight : 30,
        
        // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
        skipReadonlyColumns : true,
        
        // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
        wrapSelectionMove : true,
        
        // 줄번호 칼럼 렌더러 출력
        showRowNumColumn : false,

    };
    
    //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
    myGridID = AUIGrid.create("#grid_wrap_asList", columnLayout, gridPros);
}

var gridPros = {
    
    // 페이징 사용       
    usePaging : true,
    
    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20,
    
    editable : true,
    
    fixedColumnCount : 1,
    
    showStateColumn : true, 
    
    displayTreeOpen : true,
    
    selectionMode : "singleRow",
    
    headerHeight : 30,
    
    // 그룹핑 패널 사용
    useGroupingPanel : true,
    
    // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
    skipReadonlyColumns : true,
    
    // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
    wrapSelectionMove : true,
    
    // 줄번호 칼럼 렌더러 출력
    showRowNumColumn : false,
    
};

function fn_excelDown(){
    // type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
    GridCommon.exportTo("grid_wrap_asList", "xlsx", "AS Management");
}
</script>
<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>AS Management</h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a href="#" onClick="javascript:fn_searchASManagement()"><span class="search"></span>Search</a></p></li>
    <li><p class="btn_blue"><a href="#"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="ASForm">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">AS Type</th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="asType" name="asType">
    <option value="675">Auto AS</option>
    <option value="674">Normal AS</option>
    <option value="">Request AS</option>
    </select>
    </td>
    <th scope="row">AS Status</th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="asStatus" name="asStatus">
    <option value="1"  selected>Active</option>
    <option value="4">Completed</option>
    <option value="21">Fail</option>
    <option value="10">Cancelled</option>
    </select>
    </td>
    <th scope="row">Request Date</th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="createStrDate"  name="createStrDate"/></p>
    <span>To</span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="createEndDate" name="createEndDate"/></p>
    </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row">AS Number</th>
    <td><input type="text" title="" placeholder="AS Number" class="w100p" id="asNum" name="asNum"/></td>
    <th scope="row">Result Number</th>
    <td><input type="text" title="" placeholder="Result Number" class="w100p" id="resultNum" name="resultNum"/></td>
    <th scope="row">Order Number</th>
    <td><input type="text" title="" placeholder="Order Number" class="w100p" id="orderNum" name="orderNum"/></td>
</tr>
<tr>
    <th scope="row">Customer Name</th>
    <td colspan="3"><input type="text" title="" placeholder="Customer Name" class="w100p" id="custName" name="custName"/></td>
    <th scope="row">NRIC/Company No</th>
    <td><input type="text" title="" placeholder="NRIC/Company Number" class="w100p" id="nricNum"  name="nricNum"/></td>
</tr>
</tbody>
</table><!-- table end -->

 <aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
    <dt>Link</dt>
    <dd>
    <ul class="btns">
        <li><p class="link_btn"><a href="#" onclick="javascript:fn_asAppViewPop()"> AS Application View</a></p></li>
        <li><p class="link_btn"><a href="#" onclick="javascript:fn_viewASResultPop()"> AS Application Edit</a></p></li>
        <li><p class="link_btn"><a href="#" onclick="javascript:fn_newASResultPop()">New AS Result</a></p></li>
        <li><p class="link_btn"><a href="#" onclick="javascript:fn_asResultViewPop()"> AS Result  View</a></p></li>
         <!--<li><p class="link_btn"><a href="#" onclick="javascript:fn_asResultEditPop()"> AS Result  Edit</a></p></li>-->
        <li><p class="link_btn"><a href="#" onclick="javascript:fn_asResultEditBasicPop()"> AS Result  Edit(Basic)</a></p></li>
        
        
        
        
       <!--  <li><p class="link_btn"><a href="#">menu2</a></p></li>
        <li><p class="link_btn"><a href="#">menu3</a></p></li>
        <li><p class="link_btn"><a href="#">menu4</a></p></li>
        <li><p class="link_btn"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn"><a href="#">menu6</a></p></li>
        <li><p class="link_btn"><a href="#">menu7</a></p></li>
        <li><p class="link_btn"><a href="#">menu8</a></p></li> -->
    </ul>
    <ul class="btns">
        <li><p class="link_btn type2"><a href="#" onclick="javascript:fn_newASPop()">New AS Application</a></p></li>
        <!-- <li><p class="link_btn type2"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu3</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu4</a></p></li>
        <li><p class="link_btn type2"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu6</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu7</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu8</a></p></li> -->
    </ul>
    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside><!-- link_btns_wrap end -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#" onClick="fn_excelDown()">EXCEL DW</a></p></li>
    <!-- <li><p class="btn_grid"><a href="#">EDIT</a></p></li>
    <li><p class="btn_grid"><a href="#">NEW</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#">INS</a></p></li>
    <li><p class="btn_grid"><a href="#">ADD</a></p></li> -->
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_wrap_asList" style="width: 100%; height: 500px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->

</form>
</section><!-- search_table end -->

</section><!-- content end -->
