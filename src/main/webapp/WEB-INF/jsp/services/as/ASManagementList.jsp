<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">
var option = {
        width : "1200px",   // 창 가로 크기
        height : "500px"    // 창 세로 크기
};


var myGridID;

function fn_searchASManagement(){
	
	//Gap
    var startDate = $('#createStrDate').val();
    var endDate = $('#createEndDate').val();
    
    
    if( fn_getDateGap(startDate , endDate) > 90){
        Common.alert('Start date can not be more than 90 days before the end date.');
        //
        return;
    }
    



     Common.ajax("GET", "/services/as/searchASManagementList.do", $("#ASForm").serialize(), function(result) {
         console.log("성공.");
         console.log( result);
         AUIGrid.setGridData(myGridID, result);
     });
}



function fn_newASPop(){
	
	var selectedItems = AUIGrid.getCheckedRowItems(myGridID);
	var ordno ;
	
    if(selectedItems.length  >  0) {
    	 if("ASR" !=  selectedItems[0].item.code ){
    		 Common.alert("<b> No ARS selected.</b>");
    		 return ;
    	 }
         ordno  =selectedItems[0].item.salesOrdNo;
    }
    
	
    Common.popupDiv("/services/as/ASReceiveEntryPop.do" ,{in_ordNo: ordno}, null , true , '_NewEntryPopDiv1');
    
}


function fn_viewASResultPop(){
	
    
    var selectedItems = AUIGrid.getCheckedRowItems(myGridID);
	
    if(selectedItems.length  <= 0) {
        Common.alert("<b>No AS selected.</b>");
        return ;
    }
    
    if(selectedItems.length  > 1) {
        Common.alert("<b>only select one row plz</b>");
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
    
	Common.popupDiv("/services/as/resultASReceiveEntryPop.do?mod=VIEW&salesOrderId="+ordId+"&ordNo="+ordno+"&AS_NO="+AS_NO+'&AS_ID='+AS_ID  ,null, null , true , '_viewEntryPopDiv1');
    
}



function fn_resultASPop(ordId,ordNo){
	
      var selectedItems = AUIGrid.getCheckedRowItems(myGridID);
	  var mafuncId="";
	  var mafuncResnId="";
	  var asId="";
      
      if(selectedItems.length  >  0) {
    	  
           if("ASR" !=  selectedItems[0].item.code ){
               Common.alert("<b> No ARS selected.</b>");
               return ;
           }
           mafuncId = selectedItems[0].item.asMalfuncId;
           mafuncResnId =selectedItems[0].item.asMalfuncResnId;
           asId=selectedItems[0].item.asId;
      }
      
      var pram = "?salesOrderId="+ordId+"&ordNo="+ordNo+"&mafuncId="+mafuncId+"&mafuncResnId="+mafuncResnId+"&AS_ID="+asId;
 
	Common.popupDiv("/services/as/resultASReceiveEntryPop.do"+pram  ,null, null , true , '_resultNewEntryPopDiv1');
	
}





function fn_newASResultPop(){
	
    var selectedItems = AUIGrid.getCheckedRowItems(myGridID);
    
    if(selectedItems.length  <= 0) {
        Common.alert("<b>No AS selected.</b>");
        return ;
    }
    
    if(selectedItems.length  > 1) {
        Common.alert("<b>only select one row plz</b>");
        return ;
    }
    
    
    var asid =    selectedItems[0].item.asId;
    var asNo =    selectedItems[0].item.asNo;
    var asStusId     = selectedItems[0].item.code1;
    var salesOrdNo  = selectedItems[0].item.salesOrdNo;
    var salesOrdId  =selectedItems[0].item.asSoId;
    var refReqst  =selectedItems[0].item.refReqst;
    
    
    
    if(asStusId  !="ACT"){
    	  Common.alert("<b>[" + asNo + "] already has [" + asStusId + "] result.  .</br> Result entry is disallowed.</b>");
          return ;
    }
    
    var param = "?ord_Id="+salesOrdId+"&ord_No="+salesOrdNo+"&as_No="+asNo+"&as_Id="+asid+"&refReqst="+refReqst;
    Common.popupDiv("/services/as/ASNewResultPop.do"+param ,null, null , true , '_newASResultDiv1');
}




function fn_asAppViewPop(){
    
    var selectedItems = AUIGrid.getSelectedItems(myGridID);
    
    if(selectedItems.length  <= 0) {
        Common.alert("<b>No AS selected.</b>");
        return ;
    }
    

    
    if(selectedItems.length  > 1) {
        Common.alert("<b>only select one row plz</b>");
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
	
	
    var selectedItems = AUIGrid.getCheckedRowItems(myGridID);
    
    if(selectedItems.length  <= 0) {
        Common.alert("<b>No AS selected.</b>");
        return ;
    }
    

    
    if(selectedItems.length  > 1) {
        Common.alert("<b>only select one row plz</b>");
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
  
  var param = "?ord_Id="+salesOrdId+"&ord_No="+salesOrdNo+"&as_No="+asNo+"&as_Id="+asid+"&mod=RESULTVIEW&as_Result_No="+asResultNo;
 
  Common.popupDiv("/services/as/asResultEditViewPop.do"+param ,null, null , true , '_newASResultDiv1');
  
	
}



function fn_asInhouseAddOrderPop(){
	

    var selectedItems = AUIGrid.getCheckedRowItems(myGridID);
    
    if(selectedItems.length  <= 0) {
        Common.alert("<b>No AS selected.</b>");
        return ;
    }
    

    if(selectedItems.length  > 1) {
        Common.alert("<b>only select one row plz</b>");
        return ;
    }
    
    console.log(selectedItems);
    var asid =    selectedItems[0].item.asId;
    var asNo =    selectedItems[0].item.asNo;
    
    var asStusId      = selectedItems[0].item.code1;
    var salesOrdNo  =selectedItems[0].item.salesOrdNo;
    var salesOrdId   =selectedItems[0].item.asSoId;
    var apptype       =selectedItems[0].item.code;
    var asResultNo   =selectedItems[0].item.c3;
    var asResultId    =selectedItems[0].item.asResultId;
    
    
    
    if(apptype  !="IHR"){
        Common.alert("only select for In-House Repair ");
        return ;
    }
    
    
   // if(asStusId  !="ACT"){
   //     Common.alert("<b> already has [" + asResultNo + "] result.  .</br> Result entry is disallowed.</b>");
    //    return ;
  //}
	 
    
    //$("#in_asResultId").val(asResultId);
    //$("#in_asResultNo").val(asResultNo);
     
    
    Common.popupDiv("/services/as/resultASReceiveEntryPop.do?salesOrderId="+salesOrdId+"&ordNo="+salesOrdNo+"&asResultId="+asResultId ,null, null , true , '_resultNewEntryPopDiv1');

    
    
    //Common.popupDiv("/services/as/ASReceiveEntryPop.do" ,$("#inHOForm").serializeJSON()  , null , true , '_newInHouseEntryDiv1');
  
}


function fn_asResultEditPop(){

    var selectedItems = AUIGrid.getCheckedRowItems(myGridID);
    
    if(selectedItems.length  <= 0) {
        Common.alert("<b>No AS selected.</b>");
        return ;
    }
    

    if(selectedItems.length  > 1) {
        Common.alert("<b>only select one row plz</b>");
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
    	if(selectedItems[0].item.asSlutnResnId =='454' ){
    		
    	}else{
            Common.alert("<b>[" + asNo + "] do no has any result yet. .</br> Result view is disallowed.");
            return ;
    	}
   }
    console.log(selectedItems[0].item);
    
    
  if(asResultNo  ==""){
        Common.alert("<b>[" + asNo + "] do no has any result yet. .</br> Result view is disallowed.");
        return ;
  }
  
  var param = "?ord_Id="+salesOrdId+"&ord_No="+salesOrdNo+"&as_No="+asNo+"&as_Id="+asid+"&mod=RESULTEDIT&as_Result_No="+asResultNo+"&as_Result_Id="+asResultId;
  Common.popupDiv("/services/as/asResultEditViewPop.do"+param ,null, null , true , '_newASResultDiv1');
    
}



function fn_asResultEditBasicPop(){

    var selectedItems = AUIGrid.getCheckedRowItems(myGridID);
    
    if(selectedItems.length  <= 0) {
        Common.alert("<b>No AS selected.</b>");
        return ;
    }
    

    if(selectedItems.length  > 1) {
        Common.alert("<b>only select one row plz</b>");
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
    var refReqst     =selectedItems[0].item.refReqst;
    
    
    if(asStusId  =="ACT"){
    	
        if(  refReqst =="" ){   //inhoouse는  수정 가능 
            Common.alert("<b>[" + asNo + "] do no has any result yet. .</br> Result view is disallowed.");
            return ;
        }
    }
    console.log(selectedItems[0].item);
    
    
  if(asResultNo  ==""){
        Common.alert("<b>[" + asNo + "] do no has any result yet. .</br> Result view is disallowed.");
        return ;
  }
  
  var param = "?ord_Id="+salesOrdId+"&ord_No="+salesOrdNo+"&as_No="+asNo+"&as_Id="+asid+"&mod=edit&as_Result_No="+asResultNo+"&as_Result_Id="+asResultId;
  Common.popupDiv("/services/as/asResultEditBasicPop.do"+param ,null, null , true , '_newASResultBasicDiv1');
    
}



function fn_assginCTTransfer(){
	
    var selectedItems = AUIGrid.getCheckedRowItems (myGridID);
    

    if(selectedItems.length  <= 0) {
        Common.alert("<b>No AS selected.</b>");
        return ;
    }
   
    
    var asBrnchId = selectedItems[0].item.asBrnchId;
    
    for( var  i in selectedItems){
    	 console.log("===>"+ selectedItems[i].item.asBrnchId);
    	 
    	 if("ACT" != selectedItems[i].item.code1 ){
             Common.alert("<b>[" + selectedItems[i].item.asNo + "] do no has any result yet. .</br> Result view is disallowed.");
             return ;
         }
    	 
    	 if(asBrnchId != selectedItems[i].item.asBrnchId ){
    		 Common.alert("<b>Can't CT tranfer in multiple branch selection.</b>");
    		 return ;
    	 }
    }
    
	 Common.popupDiv("/services/as/assignCTTransferPop.do"  , null, null , true , '_assginCTTransferDiv');
}



$(document).ready(function() {

    // AUIGrid 그리드를 생성합니다.
    asManagementGrid();
    
    AUIGrid.setSelectionMode(myGridID, "singleRow");
    
    doGetCombo('/services/holiday/selectBranchWithNM', 43, '','cmbbranchId', 'S' ,  '');
    
	$("#cmbbranchId").change(function (){
		doGetCombo('/services/as/selectCTByDSC.do',  $("#cmbbranchId").val(), '','cmbctId', 'S' ,  '');
	});
    
    // 셀 더블클릭 이벤트 바인딩
    AUIGrid.bind(myGridID, "cellDoubleClick", function(event) {
        var asid =    AUIGrid.getCellValue(myGridID, event.rowIndex, "asId");
        var asNo =    AUIGrid.getCellValue(myGridID, event.rowIndex, "asNo");
        var asStusId     = AUIGrid.getCellValue(myGridID, event.rowIndex, "asStusId");
        var salesOrdNo  = AUIGrid.getCellValue(myGridID, event.rowIndex, "salesOrdNo");
        var salesOrdId  = AUIGrid.getCellValue(myGridID, event.rowIndex, "asSoId");
        
        var param = "?ord_Id="+salesOrdId+"&ord_No="+salesOrdNo+"&as_No="+asNo+"&as_Id="+asid;
        Common.popupDiv("/services/as/asResultViewPop.do"+param ,null, null , true , '_newASResultDiv1');
    });   
  
    
    var objDate = new Date();
    // 년 구하기
    var year = objDate.getFullYear() ; 
    // 월 구하기
    var month = addZeroInDate(objDate.getMonth()); 
    // 일 구하기
    var date= addZeroInDate(objDate.getDate() );
    
    var month2 = addZeroInDate(objDate.getMonth() + 1); 
    
    
    $("#createStrDate").val(date+'/'+month +'/'+year);
    $("#createEndDate").val(date+'/'+month2 +'/'+year);
    
});    
    


function addZeroInDate(value){
	if(value < 10){
		value = "0" + value;
	}
	return value
}

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
    },{
        dataField : "brnchCode",
        headerText : "AS BRNCH",
        width : 100 
    },{
        dataField : "asIfFlag",
        headerText : "AS_IF_FLAG",  
        width : 80 
    } , {
        dataField : "asBrnchId",
        headerText : "as asBrnc",
        width : 100,  visible : false
    }, {
        dataField : "c5",
        headerText : "asTotalAmt",
        width : 100,  visible : false
    }, {
        dataField : "asResultId",
        headerText : "asResultId",
        width : 100,  visible : false
    }, {
        dataField : "undefined",
        headerText : "Edit",
        width : 170,
        renderer : {
              type : "ButtonRenderer",
              labelText : "Edit",
              onclick : function(rowIndex, columnIndex, value, item) {
                   
                  var AS_ID =    AUIGrid.getCellValue(myGridID, rowIndex, "asId");
                  var AS_NO =    AUIGrid.getCellValue(myGridID, rowIndex, "asNo");  
                  var asStusId     = AUIGrid.getCellValue(myGridID, rowIndex, "code1");
                  var ordno  = AUIGrid.getCellValue(myGridID, rowIndex, "salesOrdNo");
                  var ordId  = AUIGrid.getCellValue(myGridID, rowIndex, "asSoId");
                  
                  if(asStusId  !="ACT"){
                        Common.alert( "AS Info Edit Restrict</br>" +DEFAULT_DELIMITER+"<b>[" + AS_NO + "]  is not in active status.</br> AS information edit is disallowed.</b>" );
                        return ;
                  }
                  
                  Common.popupDiv("/services/as/resultASReceiveEntryPop.do?mod=VIEW&salesOrderId="+ordId+"&ordNo="+ordno+"&AS_NO="+AS_NO  ,null, null , true , '_viewEntryPopDiv1'); 
                  }
        }                            
	}  
    
    ];
     // 그리드 속성 설정
    var gridPros = {
    	       showRowCheckColumn : true,
               // 페이징 사용       
               usePaging : true,
               // 한 화면에 출력되는 행 개수 20(기본값:20)
               pageRowCount : 20,
               // 전체 체크박스 표시 설정
               showRowAllCheckBox : true,
               editable :  false,
               selectionMode:"multipleCells"
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

function fn_ASReport(){
    Common.popupDiv("/services/as/report/asReportPop.do"  , null, null , true , '');
}
function fn_asLogBookList(){
    Common.popupDiv("/services/as/report/asLogBookListPop.do"  , null, null , true , '');
}
function fn_asRawData(){
    Common.popupDiv("/services/as/report/asRawDataPop.do"  , null, null , true , '');
}
function fn_asSummaryList(){
    Common.popupDiv("/services/as/report/asSummaryListPop.do"  , null, null , true , '');
}
function fn_asYsList(){
    Common.popupDiv("/services/as/report/asYellowSheetPop.do"  , null, null , true , '');
}
function fn_ledger(){
    
    var selectedItems = AUIGrid.getCheckedRowItems(myGridID);
    
       if(selectedItems.length  <= 0) {
           Common.alert("<b>No AS selected.</b>");
           return ;
       }
       else{
       
	    var asStusId =    selectedItems[0].item.code1;
	    var asrNo =    selectedItems[0].item.c3;
	    var AS_NO =    selectedItems[0].item.asNo;
	    
	    if (asStusId == "ACT")
        {
	    	Common.alert("<b>[" + AS_NO + "] do no has any result yet. Ledger view is disallowed.</b>");
        }
	    else{
		   Common.popupDiv("/services/as/report/asLedgerPop.do?ASRNO="+asrNo  , null, null , true , '');
	    	
		   }
       }
}
function fn_invoice(){
      var selectedItems = AUIGrid.getCheckedRowItems(myGridID);
      
      if(selectedItems.length  <= 0) {
          Common.alert("<b>No AS selected.</b>");
          return ;
      }
      
       var AS_ID =    selectedItems[0].item.asId;
       var AS_NO =    selectedItems[0].item.asNo;
       var asStusId =    selectedItems[0].item.code1;
       var asrId =    selectedItems[0].item.asResultId;
       var asTotalAmt = selectedItems[0].item.c5;
       var date = new Date();
       var month = date.getMonth()+1;
       var day = date.getDate();
       if(date.getDate() < 10){
           day = "0"+date.getDate();
       }
       
       if (asStusId != "COM")
       {
           Common.alert("<b>[" + AS_NO + "] is not in complete status. Print invoice is disallowed.</b>");
       }
       else{
           if (asTotalAmt <= 0)
           {
               Common.alert("<b>[" + AS_NO + "] has no charges. Print invoice is disallowed.</b>");
           }
           else{
               $("#reportForm #V_RESULTID").val(asrId);
               $("#reportForm #reportFileName").val('/services/ASInvoice.rpt');
               $("#reportForm #viewType").val("PDF");
               $("#reportForm #reportDownFileName").val("ASInvoice_"+day+month+date.getFullYear());
               
             //report 호출
               var option = {
                       isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
               };
               
               Common.report("reportForm", option);
           }
       }
}




function fn_getDateGap(sdate, edate){
    
    var startArr, endArr;
    
    startArr = sdate.split('/');
    endArr = edate.split('/');
    
    var keyStartDate = new Date(startArr[2] , startArr[1] , startArr[0]);
    var keyEndDate = new Date(endArr[2] , endArr[1] , endArr[0]);
    
    var gap = (keyEndDate.getTime() - keyStartDate.getTime())/1000/60/60/24;
    
//    console.log("gap : " + gap);
    
    return gap;
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

<form action="#" id="inHOForm">
<div   style="display:none" >

	<input type="text" id="in_asId" name="in_asId" />
	<input type="text" id="in_asNo" name="in_asNo" />
	<input type="text" id="in_ordId" name="in_ordId" />
	<input type="text" id="in_asResultId" name="in_asResultId" />
	<input type="text" id="in_asResultNo" name="in_asResultNo" />
	
</div>
</form>

<!-- 
<ul class="right_btns">
    <li><p class="btn_blue"><a href="#" onclick="javascript:()">ADD AS Order</a></p></li>
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_newASResultPop()">ADD AS Result</a></p></li>
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_asResultEditBasicPop()">EDIT AS Result</a></p></li>
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_asResultViewPop()"> VIEW AS Result</a></p></li>
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_assginCTTransfer()">Assign CT Transfer</a></p></li>
</ul>
<br> -->

<ul class="right_btns">
    
    <!-- 
<c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_asInhouseAddOrderPop()">IHR ADD AS Order</a></p></li>
</c:if>     -->
<c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_newASPop()">ADD AS Order</a></p></li>
</c:if>     
<c:if test="${PAGE_AUTH.funcUserDefine4 == 'Y'}">
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_newASResultPop()">ADD AS Result</a></p></li>
</c:if>    
<c:if test="${PAGE_AUTH.funcUserDefine5 == 'Y'}">    
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_asResultEditBasicPop()">EDIT(Basic) AS Result</a></p></li>
</c:if>
<c:if test="${PAGE_AUTH.funcUserDefine9 == 'Y'}">    
      <li><p class="btn_blue"><a href="#" onclick="javascript:fn_asResultEditPop()"> EDIT AS Result </a></p></li>
</c:if>      

<c:if test="${PAGE_AUTH.funcUserDefine6 == 'Y'}">  
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_asResultViewPop()"> VIEW AS Result</a></p></li>
</c:if>    
<c:if test="${PAGE_AUTH.funcUserDefine7 == 'Y'}">
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_assginCTTransfer()">Assign CT Transfer</a></p></li>
</c:if>    
<c:if test="${PAGE_AUTH.funcView == 'Y'}">    
    <li><p class="btn_blue"><a href="#" onClick="javascript:fn_searchASManagement()"><span class="search"></span>Search</a></p></li>
</c:if>    
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
    <option value="2703">Request AS</option>
    <option value="2713">InHouseRepair</option>
    
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
    <th scope="row">DSC</th>
    <td>
    <select id="cmbbranchId" name="cmbbranchId" class="w100p" >
        <%-- <option value="">Choose One</option>
         <c:forEach var="list" items="${ssCapacityCtList }">
            <option value="${list.codeId }">${list.codeName }</option>
            <option value="${list.codeId }">${list.codeName }</option>
         </c:forEach> --%>
    </select>
    </td>
    <th scope="row">CT</th>
    <td>
    <select id="cmbctId" name="cmbctId" class="w100p" >
        <%-- <option value="">Choose One</option>
         <c:forEach var="list" items="${selectCTSubGroupDscList }">
            <option value="${list.codeId }">${list.codeName }</option>
         </c:forEach> --%>
    </select>
    </td>
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

      
        <!-- <li><p class="link_btn"><a href="#" ondblclick="javascript:fn_asAppViewPop()"> AS Application View</a></p></li> -->
        <!-- <li><p class="link_btn"><a href="#" onclick="javascript:fn_viewASResultPop()"> AS Application Edit</a></p></li> -->
        <!-- <li><p class="link_btn"><a href="#" onclick="javascript:fn_newASResultPop()">New AS Result</a></p></li>
        <li><p class="link_btn"><a href="#" onclick="javascript:fn_asResultViewPop()"> AS Result  View</a></p></li>
      
        <li><p class="link_btn"><a href="#" onclick="javascript:fn_assginCTTransfer()"> AssginCTTransfer</a></p></li> -->
        
        
        
        
        
        
       <!--  <li><p class="link_btn"><a href="#">menu2</a></p></li>
        <li><p class="link_btn"><a href="#">menu3</a></p></li>
        <li><p class="link_btn"><a href="#">menu4</a></p></li>
        <li><p class="link_btn"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn"><a href="#">menu6</a></p></li>
        <li><p class="link_btn"><a href="#">menu7</a></p></li>
        <li><p class="link_btn"><a href="#">menu8</a></p></li> -->
    </ul>
    <ul class="btns">
<c:if test="${PAGE_AUTH.funcUserDefine8 == 'Y'}">    
        <li><p class="link_btn type2"><a href="#" onclick="javascript:fn_ASReport()">AS Report</a></p></li>
        <li><p class="link_btn type2"><a href="#" onclick="javascript:fn_asLogBookList()">AS Log Book List</a></p></li>
        <li><p class="link_btn type2"><a href="#" onclick="javascript:fn_asRawData()">AS Raw Data</a></p></li>
        <li><p class="link_btn type2"><a href="#" onclick="javascript:fn_asSummaryList()">AS Summary List</a></p></li>
        <li><p class="link_btn type2"><a href="#" onclick="javascript:fn_asYsList()">AS YS List</a></p></li>
         <li><p class="link_btn type2"><a href="#" onclick="javascript:fn_ledger()">View Ledger</a></p></li>
         <li><p class="link_btn type2"><a href="#" onclick="javascript:fn_invoice()">AS Invoice</a></p></li>
</c:if>         
    </ul> 
    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside><!-- link_btns_wrap end -->

<ul class="right_btns">
<c:if test="${PAGE_AUTH.funcUserDefine10 == 'Y'}">
    <li><p class="btn_grid"><a href="#" onClick="fn_excelDown()">GENERATE</a></p></li>
</c:if>    
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
<form action="#" id="reportForm" method="post">  
<input type="hidden" id="V_RESULTID" name="V_RESULTID" />
<input type="hidden" id="reportFileName" name="reportFileName" />
<input type="hidden" id="viewType" name="viewType" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="DOWN_FILE_NAME" />
</form>
</section><!-- search_table end -->

</section><!-- content end -->
