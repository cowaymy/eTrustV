<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>



<script type="text/javaScript" language="javascript">

var trGridID;
var addGridID;

$(document).ready(function(){
	
    fn_getConfigDataInfo();
    
	//fn_setComboBox();
    
    tr_CreateAUIGrid();
    
    
    //add_CreateAUIGrid();
    // 행 추가 이벤트 바인딩 
    AUIGrid.bind(trGridID, "addRow", auiAddRowHandler);
    // 행 삭제 이벤트 바인딩 
    AUIGrid.bind(trGridID, "removeRow", auiRemoveRowHandler);

    
    //j_date
    var pickerOpts={
            changeMonth:true,
            changeYear:true,
            dateFormat: "dd/mm/yy"
    };
    
    $(".j_date").datepicker(pickerOpts);
    
    fn_keyEvent();
    
    
    $("#confirmbt").attr("style" ,"display:inline");
    $("#searchbt").attr("style" ,"display:inline");
    $("#resetbt").attr("style" ,"display:none");

});


function  fn_keyEvent(){
	
	/*
	  $("#CASH_AMOUNT").keyup(function(e){
          regex = /[^0-9]/gi;
          v = $(this).val();
          if (regex.test(v)) {
              var nn = v.replace(regex, '');
              $(this).val(v.replace(regex, ''));
              $(this).focus();
              return;
          }
      });  
	  
	  $("#CASH_BANK_CHARGE_AMT").keyup(function(e){
          regex = /[^0-9]/gi;
          v = $(this).val();
          if (regex.test(v)) {
              var nn = v.replace(regex, '');
              $(this).val(v.replace(regex, ''));
              $(this).focus();
              return;
          }
      });  
	  
	  */
}


function fn_setComboBox(){
	//CASH  ,  ONLINE ,  CHQ , CRC
    doGetCombo('/sales/membership/paymentGetAccountCode', 'CASH', '','SEL_CASH_BANK_ACC', 'S' , 'f_EvCombo');    
}


// 행 추가 이벤트 핸들러
function auiAddRowHandler(event) {
	
}

// 행 삭제 이벤트 핸들러
function auiRemoveRowHandler(event) {

}

function f_EvCombo(){
}


 function tr_CreateAUIGrid(){
         
            var columnLayout = [ 
                                 {dataField : "type",       headerText : "Type",    width :300}, 
                                 {dataField : "trNo",       headerText : "TR No",    width : 100},
                                 {dataField : "issDate",   headerText : "Issued Date",  width : 200},
	                             {
			                            dataField : "undefined",
			                            headerText : " ",
			                            width           : 110,    
			                            renderer : {
			                                type : "ButtonRenderer",
			                                labelText : "Remove",
			                                onclick : function(rowIndex, columnIndex, value, item) {
			                                	 AUIGrid.removeRow(trGridID, rowIndex);
			                                }
			                            }
			                        },
	                                 {
	                                     dataField : "trId",
	                                     visible : false
	                                        }
           ];
            
            //그리드 속성 설정
            var gridPros = {
            	    usePaging           : false,         //페이징 사용
                    editable            : false,            
                    showStateColumn     : true,             
                    displayTreeOpen     : false,            
                    selectionMode       : "singleRow",  //"multipleCells",            
                    headerHeight        : 30,       
                    useGroupingPanel    : false,        //그룹핑 패널 사용
                    skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
                    wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
                    showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력    
                    noDataMessage       : "No order found.",
                    groupingMessage     : "Here groupping",
                    softRemovePolicy : "exceptNew"
                };
        
            trGridID = GridCommon.createAUIGrid("tr_grid_wrap",columnLayout,'', gridPros);  
}
        
 
 function add_CreateAUIGrid(){

			var columnLayout = [ 
			            {
			                dataField : "undefined",
			                headerText : "remove ",
			                width           : 50,    
			                renderer : {
			                    type : "ButtonRenderer",
			                    labelText : "Remove",
			                    onclick : function(rowIndex, columnIndex, value, item) {
			                         //AUIGrid.removeRow(trGridID, rowIndex);
			                    }
			                }
			            },
			            {
			                dataField : "undefined",
			                headerText : "copy ",
			                width           : 50,    
			                renderer : {
			                    type : "ButtonRenderer",
			                    labelText : "Copy",
			                    onclick : function(rowIndex, columnIndex, value, item) {
			                         //AUIGrid.removeRow(trGridID, rowIndex);
			                    }
			                }
			            },
			            {dataField : "modeId",       headerText : "modeId",      width :160}, 
			            {dataField : "modeName",     headerText : "modeName",    width :160}, 
			            {dataField : "refNo",        headerText : "refNo",       width :160}, 
			            {dataField : "cCNo",         headerText : "cCNo",        width :160}, 
			            {dataField : "cCTypeId",     headerText : "cCTypeId",    width :160}, 
			            {dataField : "cCTypeName",   headerText : "cCTypeName",  width :160}, 
			            {dataField : "cCExpiry",     headerText : "cCExpiry",    width :160}, 
			            {dataField : "cCOwner",      headerText : "cCOwner",     width :160}, 
			            {dataField : "chqNo",        headerText : "chqNo",       width :160}, 
			            {dataField : "issueBankId",  headerText : "issueBankId", width :160}, 
			            {dataField : "issueBankCode",headerText : "issueBankCode",width :160}, 
			            {dataField : "amount",       headerText : "amount",      width :160}, 
			            {dataField : "isOnline",     headerText : "isOnline",    width :160}, 
			            {dataField : "isOnlineStr",  headerText : "isOnlineStr", width :160}, 
			            {dataField : "bankAccId",    headerText : "bankAccId",   width :160}, 
			            {dataField : "bankAccCode",  headerText : "bankAccCode", width :160}, 
			            {dataField : "refDate",      headerText : "refDate",     width :160}, 
			            {dataField : "appvNo",       headerText : "appvNo",      width :160}, 
			            {dataField : "remark",       headerText : "remark",      width :160}, 
			            {dataField : "bCAmt",        headerText : "bCAmt",       width :160}, 
			            {dataField : "bankBranchId", headerText : "bankBranchId",width :160}, 
			            {dataField : "bankInSlipNo", headerText : "bankInSlipNo",width :160}, 
			            {dataField : "eFTNo",        headerText : "eFTNo",       width :160}, 
			            {dataField : "chqDepositNo", headerText : "chqDepositNo",width :160}, 
			            {dataField : "runningNo",    headerText : "runningNo",   width :160}, 
			            {dataField : "cardTypeId",   headerText : "cardTypeId",  width :160}, 
			            {dataField : "cardType",     headerText : "cardType",    width :160}, 
			            {dataField : "cRCModeId",    headerText : "cRCModeId",   width :160}, 
			            {dataField : "payTypeId",    headerText : "payTypeId",   width :160}, 
			            {dataField : "refItemNo",    headerText : "refItemNo",   width :160}
			];
			
			
			 //그리드 속성 설정
            var gridPros = {
                    usePaging           : false,         //페이징 사용
                    editable                : true,        
                    fixedColumnCount    : 5,            
                    showStateColumn     : true,             
                    displayTreeOpen     : false,            
                    selectionMode       : "singleRow",  //"multipleCells",            
                    headerHeight        : 30,       
                    useGroupingPanel    : false,        //그룹핑 패널 사용
                    skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
                    wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
                    showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력    
                    noDataMessage       : "No order found.",
                    groupingMessage     : "Here groupping",
                    softRemovePolicy : "exceptNew"
                };
        
        
			  addGridID = GridCommon.createAUIGrid("add_grid_wrap",columnLayout,'');  
	 
 }
 


//get Last Membership  &   Expire Date
function fn_getConfigDataInfo (){ 
    Common.ajax("GET", "/sales/membership/paymentConfig", $("#getParamForm").serialize(), function(result) {
         console.log( result);
         
         $("#last_membership_text").html("");
         $("#expire_date_text").html("");
         
         
         if(result.length > 0){
        	 
             if(result[0].lastSrvMemId >0){
            	 
            	 $("#PAY_LAST_MBRSH_ID").val(result[0].lastSrvMemId );
            	 
            	 fn_getMembershipDataInfo ();
            	 fn_getMembershipChargesDataInfo();
            	 
             }else{
            	 
            	   $("#confirmbt").attr("style" ,"display:inline");
                   $("#searchbt").attr("style" ,"display:inline");
                   $("#resetbt").attr("style" ,"display:none");
                      
             }
         }
    });
 }
 
 

//get Last Membership  &   Expire Date
function fn_getMembershipDataInfo (){ 
  Common.ajax("GET", "/sales/membership/paymentLastMembership", $("#getParamForm").serialize(), function(result) {
       console.log( result);
       
       $("#last_membership_text").html( result[0].pacCode +" "+ result[0].pacName);
       $("#expire_date_text").html( result[0].mbrshExprDt);
  });
}


function fn_goCollecterReset(){
	
    $("#confirmbt").attr("style" ,"display:inline");
    $("#searchbt").attr("style" ,"display:inline");
    $("#resetbt").attr("style" ,"display:none");
    $("#COLL_MEM_CODE").attr("class","");
    $("#COLL_MEM_NAME").html("");
    
}



//
function fn_getMembershipAdddressDataInfo (){ 
Common.ajax("GET", "/sales/membership/paymentInsAddress", $("#getParamForm").serialize(), function(result) {
     console.log( result);
     
     //$("#ins_full_address").html("");
     //$("#ins_full_address").html(result[0].InstAddr1 +result[0].InstAddr2);
});
}



function  fn_goAddNewTr(){
   // var selectedItems = AUIGrid.getSelectedItems(gridID);
   // var pram  ="?MBRSH_ID="+selectedItems[0].item.mbrshId+"&ORD_ID="+selectedItems[0].item.ordId;
    Common.popupDiv("/sales/membership/paymentAddNewTR.do");
}



function  fn_goCollecter(){
   // var selectedItems = AUIGrid.getSelectedItems(gridID);
   // var pram  ="?MBRSH_ID="+selectedItems[0].item.mbrshId+"&ORD_ID="+selectedItems[0].item.ordId;
    Common.popupDiv("/sales/membership/paymentCollecter.do");
}


function fn_doCollecterResult(item){
	   
	   console.log(item);
	   
	    if (typeof (item) != "undefined"){
		    	
		       $("#COLL_MEM_CODE").val(item.memCode);
		       $("#COLL_MEM_NAME").html(item.name);
		       $("#confirmbt").attr("style" ,"display:none");
		       $("#searchbt").attr("style" ,"display:none");
		       $("#resetbt").attr("style" ,"display:inline");
		       $("#COLL_MEM_CODE").attr("class","readonly");
		       
	    }else{
	           $("#COLL_MEM_CODE").val("");
	           $("#COLL_MEM_NAME").html("");
	           $("#COLL_MEM_CODE").attr("class","");
	    }
}

function fn_goColleConfirm() {
	
	if($("#COLL_MEM_CODE").val() =="") {
	        
	        Common.alert("Please key in the collector code before you confirm the payment collector ");
	        return ;
	}
	    
	    
	Common.ajax("GET", "/sales/membership/paymentColleConfirm", $("#collForm").serialize(), function(result) {
	         console.log( result);
	         
	         if(result.length > 0){
	             
	             $("#COLL_MEM_CODE").val(result[0].memCode);
	             $("#COLL_MEM_NAME").html(result[0].name);
	             
                 $("#confirmbt").attr("style" ,"display:none");
                 $("#searchbt").attr("style" ,"display:none");
                 $("#resetbt").attr("style" ,"display:inline");
                 $("#COLL_MEM_CODE").attr("class","readonly");
	             
	         }else {
	        	 
                 $("#COLL_MEM_NAME").html("");
	             Common.alert(" Unable to find [" +$("#COLL_MEM_CODE").val() +"] in system. <br>  Please ensure you key in the correct member code.   ");
	             return ;
	         }
	         
	 });
		
}



function fn_resultAddNewTr(item){
	
	  console.log( item);
	  
	  if(  item.tr_type =="3"){
		  
		  var  gItem = new Object();
			      gItem.type ="Membership Package" ;
			      gItem.trNo = item.tr_number;
			      gItem.issDate = item.tr_issueddate;
			      gItem.trId ="1";
			      
			      
			     if( AUIGrid.isUniqueValue (trGridID,"trId" ,gItem.trId )){
			    	 
			    	  fn_addRow(gItem);
			     }else{
                     Common.alert("<b>Failed to bind current TR list.<br />Please try again later.</b>");
                     return ;
			     }
			     
			   
			      
			     
			      
	      var  gItem2 = new Object();
			      gItem2.type ="Filter (1st BS)" ;
			      gItem2.trNo = item.tr_number;
			      gItem2.issDate = item.tr_issueddate;
			      gItem2.trId ="2";
			      
			      if(  AUIGrid.isUniqueValue (trGridID,"trId",gItem2.trId)) {
			    	  
			    	  fn_addRow(gItem2);
	              
			     }else{
                      Common.alert("<b>Failed to bind current TR list.<br />Please try again later.</b>");
                      return ;
	              }
			      
			     
	  }else{
		 
				  var  gItem = new Object();
		          gItem.type =item.tr_text ;
		          gItem.trNo = item.tr_number;
		          gItem.issDate = item.tr_issueddate;
		          gItem.trId =item.tr_type;
		          
		          
		          if( AUIGrid.isUniqueValue (trGridID,"trId",gItem.trId )){
		        	        fn_addRow(gItem);
		          }else{
		        	  Common.alert("<b>Failed to bind current TR list.<br />Please try again later.</b>");
		              return ;
		          }
	  }
}



//행 추가, 삽입
function  fn_addRow(gItem) {	  
    AUIGrid.addRow(trGridID, gItem, "first");
}



function fn_getMembershipChargesDataInfo (){ 
	
	Common.ajax("GET", "/sales/membership/paymentCharges", $("#getParamForm").serialize(), function(result) {
	     console.log( result);
	     
	     fn_Charges_init();
	     
	          
	     $("#packageCharge").html(result.chargesInfo[0].pckgChrg);
	     $("#packagePaid").html("<font color='Red'>"+result.chargesInfo[0].pckgPaid+"</font>");
	     $("#packageDn").html(result.chargesInfo[0].pckgDn);
	     $("#packageCn").html( "<font color='Red'>"+result.chargesInfo[0].pckgCn+"</font>");
	     $("#packageRev").html(result.chargesInfo[0].pckgRev);
	     $("#packageOutstanding").html(result.chargesInfo[0].pckgOtstnd);
	     
	     $("#filterCharge").html(result.chargesInfo[0].filterChrg);
	     $("#filterPaid").html("<font color='Red'>"+result.chargesInfo[0].filterPaid+"</font>");
	     $("#filterDn").html(result.chargesInfo[0].filterDn);
	     $("#filterCn").html(result.chargesInfo[0].filterCn);
	     $("#filterRev").html("<font color='Red'>"+result.chargesInfo[0].filterCn+"</font>");
	     $("#filterOutstanding").html(result.chargesInfo[0].filterOtstnd);
	     
	});
}


function  fn_Charges_init(){
	
	$("#packageCharge").html("");
    $("#packagePaid").html("");
    $("#packageDn").html("");
    $("#packageCn").html("");
    $("#packageRev").html("");
    $("#packageOutstanding").html("");
    
    $("#filterCharge").html("");
    $("#filterPaid").html("");
    $("#filterDn").html("");
    $("#filterCn").html("");
    $("#filterRev").html("");
    $("#filterOutstanding").html("");
}

 
 
 
</script>
 





<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Membership Payment</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->



<form id="getParamForm" method="post">
<div style="display:none">

    <input type="text" name="PAY_MBRSH_ID"      id="PAY_MBRSH_ID"  value="${PAY_MBRSH_ID}"/>  
    <input type="text" name="PAY_ORD_ID"    id="PAY_ORD_ID" value="${PAY_ORD_ID}"/>  
    <input type="text" name="PAY_LAST_MBRSH_ID"    id="PAY_LAST_MBRSH_ID" />  
    <input type="text" name="QUOT_ID"  id="QUOT_ID" />
    
</div>
</form>



<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1">
    <li><a href="#" class="on">Membership Info</a></li>
    <li><a href="#">Order Info</a></li>
    <li><a href="#">Contact Info</a></li>
    <li><a href="#">Charges</a></li>
    <li><a href="#" onclick=" javascript:AUIGrid.resize(membershipQuotInfoFilterGridID, 900,300);" >Filter Charge Info</a></li>
</ul>



 <!-- inc_membershipInfo  tab  start...-->
    <jsp:include page ='${pageContext.request.contextPath}/sales/membership/inc_membershipInfo.do'/> 
<!--  inc_membershipInfotab  end...-->


<!-- oder info tab  start...-->
    <jsp:include page ='${pageContext.request.contextPath}/sales/membership/inc_orderInfo.do'/> 
<!-- oder info tab  end...-->


<!-- person info tab  start...-->
    <jsp:include page ='${pageContext.request.contextPath}/sales/membership/inc_contactPersonInfo.do'/> 
<!-- oder info tab  end...--> 

<article class="tap_area"><!-- tap_area start -->

<div class="divine_auto"><!-- divine_auto start -->

<div style="width:50%;">

<div class="border_box"><!-- border_box start -->

<aside class="title_line"><!-- title_line start -->
<h2>Package Charges</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Charges</th>
    <td><span id='packageCharge'>text</span></td>
</tr>
<tr>
    <th scope="row">Paid</th>
    <td><span id='packagePaid'  class="must">text</span></td>
</tr>
<tr>
    <th scope="row">DN</th>
    <td><span id='packageDn'>text</span></td>
</tr>
<tr>
    <th scope="row">CN</th>
    <td><span id='packageCn' class="must">text</span></td>
</tr>
<tr>
    <th scope="row">Reverse/Refund</th>
    <td><span id='packageRev'>text</span></td>
</tr>
<tr>
    <th scope="row">Total Outstanding</th>
    <td><span id='packageOutstanding'>text</span></td>
</tr>
</tbody>
</table><!-- table end -->
</div><!-- border_box end -->

</div>

<div style="width:50%;">

<div class="border_box"><!-- border_box start -->

<aside class="title_line"><!-- title_line start -->
<h2>Filter Charges</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
     
<tr>
    <th scope="row">Charges</th>
    <td><span id='filterCharge'>text</span></td>
</tr>
<tr>
    <th scope="row">Paid</th>
    <td><span id='filterPaid' class="must">text</span></td>
</tr>
<tr>
    <th scope="row">DN</th>
    <td><span id='filterDn'>text</span></td>
</tr>
<tr>
    <th scope="row">CN</th>
    <td><span id='filterCn' class="must">text</span></td>
</tr>
<tr>
    <th scope="row">Reverse/Refund</th>
    <td><span id='filterRev'>text</span></td>
</tr>
<tr>
    <th scope="row">Total Outstanding</th>
    <td><span id='filterOutstanding'>text</span></td>
</tr>
</tbody>
</table><!-- table end -->
</div><!-- border_box end -->

</div>
</div><!-- divine_auto end -->

</article><!-- tap_area end -->



<%-- <!-- person info tab  start...-->
    <jsp:include page ='/sales/membership/inc_quotFilterInfo.do'/>  
<!-- oder info tab  end...--> --%>




</section><!-- tap_wrap end -->

<aside class="title_line"><!-- title_line start -->
<h2>Payment Information</h2>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">TR Number</th>
    <td>
    <div>
    <p class="btn_sky"><a href="#" onclick="javascript:fn_goAddNewTr()">Add New TR</a></p>
    <article class="grid_wrap"><!-- grid_wrap start -->
            <div id="tr_grid_wrap" style="width:790px; height:150px; margin:0 auto;"></div>
    </article><!-- grid_wrap end -->
    </div>
    </td>
</tr>
</tbody>
</table><!-- table end -->
</form>
</section><!-- search_table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Payment Collector Information</h2>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form action="#"  id="collForm" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Collector Code</th>
    <td><input type="text" title="" placeholder="" class=""  id="COLL_MEM_CODE"  NAME="COLL_MEM_CODE"/>
        <p class="btn_sky"  id="confirmbt" ><a href="#" onclick="javascript:fn_goColleConfirm()">Confirm</a></p>  
        <p class="btn_sky"  id="searchbt"><a href="#" onclick="javascript:fn_goCollecter()" >Search</a></p>  
        <p class="btn_sky"  id="resetbt"><a href="#" onclick="javascript:fn_goCollecterReset()" >Reset</a></p>
     </td>
    <th scope="row">Collector Name</th>
    <td><span id="COLL_MEM_NAME" NAME="COLL_MEM_NAME">-</span></td>
</tr> 
<tr>
    <th scope="row">Commission</th>
    <td colspan="3">
    <label><input type="checkbox" /><span>Commission applied ?</span></label>
    </td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->




<aside class="title_line"><!-- title_line start -->
<h2>Payment Item</h2>
</aside><!-- title_line end -->

---------------------   add on for Payment Item -----------------------------


<!-- 
<ul class="center_btns mt20">
    <li><p class="btn_blue2"><a href="#">Save</a></p></li>
    <li><p class="btn_blue2"><a href="#">Back</a></p></li>
</ul>
 -->
 
 
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->


<script> 
    var quot = $("#QUOT_ID").val();
    console.log(quot);
    
    if(quot >0){ 
         fn_getMembershipQuotInfoAjax(); 
         fn_getMembershipQuotInfoFilterAjax();
    }
</script>