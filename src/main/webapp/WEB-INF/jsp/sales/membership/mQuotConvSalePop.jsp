
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">

var trGridID;



$(document).ready(function(){
    
    tr_CreateAUIGrid();
    
    // 행 추가 이벤트 바인딩 
    AUIGrid.bind(trGridID, "addRow", auiAddRowHandler);
    // 행 삭제 이벤트 바인딩   
    AUIGrid.bind(trGridID, "removeRow", auiRemoveRowHandler);
    
    
    fn_getPackageInfo ();
    fn_getConfigDataInfo();
    

    $("#confirmbt").attr("style" ,"display:inline");
    $("#searchbt").attr("style" ,"display:inline");
    $("#resetbt").attr("style" ,"display:none");
});



//행 추가 이벤트 핸들러
function auiAddRowHandler(event) {}
//행 삭제 이벤트 핸들러
function auiRemoveRowHandler(event) {}



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
         
           var gridPros = { usePaging : false,editable: false  ,     softRemovePolicy : "exceptNew" };
           trGridID = GridCommon.createAUIGrid("tr_grid_wrap",columnLayout,'', gridPros);  
}
       



function  fn_goAddNewTr(){
    Common.popupDiv("/sales/membership/paymentAddNewTR.do");
}     



//getPackageInfo 
function fn_getPackageInfo (){ 
	
	var  v_QUOT_ID = $("#QUOT_ID").val();
	
	if  ('${QUOT_ID}'  !=""){
		v_QUOT_ID = '${QUOT_ID}';
	}	
	
Common.ajax("GET", "/sales/membership/selectMembershipQuotInfo", {QUOT_ID:v_QUOT_ID  ,ORD_ID: $("#ORD_ID").val() }, function(result) {
     console.log( result);
     
     
		     fn_doQuotInfoClear();
		 
		     if(result.length > 0){
		    	 
		    	   $("#convt_quotNo").html(result[0].quotNo);
		           $("#convt_cretDt").html(result[0].crtDt);
		           $("#convt_create").html(result[0].crtUserId); 
		           $("#convt_sales").html("");
		           $("#convt_validDt").html(result[0].validDt);  
		           $("#convt_dur").html(result[0].dur+" month(s) ");     
		           
		           $("#convt_package").html(result[0].pacDesc);     
		           $("#convt_totAmt").html(result[0].totAmt);
		           $("#convt_pakAmt").html(result[0].pacAmt);  
		           $("#convt_filterAmt").html(result[0].filterAmt);  
		           $("#convt_packPromo").html(result[0].pacPromoCode +" "+ result[0].pacPromoDesc);
		           $("#convt_filterPromo").html(result[0].promoCode + " " +result[0].promoDesc);  
		           $("#convt_bsFreq").html(result[0].bsFreq +" month(s) ");  
		           
		           
		           //Contact Person Tab //MembershipQuotInfo
		              $("#inc_cntName").html(result[0].cntName);
		              $("#inc_cntNric").html(result[0].cntNric);
		              $("#inc_cntGender").html(result[0].cntGender);
		              $("#inc_cntRace").html(result[0].cntRace);
		              $("#inc_cntTelM").html(result[0].cntTelMob);
		              $("#inc_cntTelR").html(result[0].cntTelR);
		              $("#inc_cntTelO").html(result[0].cntTelO);
		              $("#inc_cntTelF").html(result[0].cntTelF);
		              $("#inc_cntEmail").html(result[0].cntEmail);
		              
		              
		              if(result[0].ordId>0){
		                  
		            	  
		            	  $("#ORD_ID").val(result[0].ordId);
		                  $("#SALES_PERSON").val(result[0].memCode);
		                  $("#SALES_PERSON_DESC").html( "<b>"+result[0].memName+"</b>");
		                  
		                  $("#sale_confirmbt").attr("style" ,"display:none");
		                  $("#sale_searchbt").attr("style" ,"display:none");
		                  $("#sale_resetbt").attr("style" ,"display:inline");
		                  $("#SALES_PERSON").attr("class","readonly");
		                  
		                  
		              }
		     }
     });
}


function fn_doQuotInfoClear(){
	    $("#convt_quotNo").html("");
	    $("#convt_cretDt").html("");
	    $("#convt_create").html("");
	    $("#convt_sales").html("");
	    $("#convt_validDt").html("");
	    $("#convt_package").html("");
	    $("#convt_totAmt").html("");
	    $("#convt_pakAmt").html("");
	    $("#convt_filterAmt").html("");
	    $("#convt_packPromo").html("");
	    $("#convt_filterPromo").html("");
	    $("#convt_bsFreq").html("");
	    
	     $("#inc_cntName").html("");
         $("#inc_cntNric").html("");
         $("#inc_cntGender").html("");
         $("#inc_cntRace").html("");
         $("#inc_cntTelM").html("");
         $("#inc_cntTelR").html("");
         $("#inc_cntTelO").html("");
         $("#inc_cntTelF").html("");
         $("#inc_cntEmail").html("");
}



function  fn_goCollecter(){
   // var selectedItems = AUIGrid.getSelectedItems(gridID);
   // var pram  ="?MBRSH_ID="+selectedItems[0].item.mbrshId+"&ORD_ID="+selectedItems[0].item.ordId;
    Common.popupDiv("/sales/membership/paymentCollecter.do?resultFun=C");
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



function fn_goCollecterReset(){
    
    $("#confirmbt").attr("style" ,"display:inline");
    $("#searchbt").attr("style" ,"display:inline");
    $("#resetbt").attr("style" ,"display:none");
    $("#COLL_MEM_CODE").attr("class","");
    $("#COLL_MEM_NAME").html("");
    
}





//get Last Membership  &   Expire Date
function fn_getConfigDataInfo (){ 
	
  Common.ajax("GET", "/sales/membership/paymentConfig", {PAY_ORD_ID:$("#ORD_ID").val()  }, function(result) {
       console.log( result);
       
       $("#last_membership_text").html("");
       $("#expire_date_text").html("");
       
       
       if(result.length > 0){
           
           if(result[0].lastSrvMemId >0){
               
               $("#LAST_MBRSH_ID").val(result[0].lastSrvMemId );
               
               fn_getMembershipDataInfo ();
               //fn_getMembershipChargesDataInfo();
               
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
	Common.ajax("GET", "/sales/membership/paymentLastMembership", {PAY_LAST_MBRSH_ID : $("#LAST_MBRSH_ID").val() },  function(result) {
	     console.log( result);
	     
	     $("#last_membership_text").html( result[0].pacCode +" "+ result[0].pacName);
	     $("#expire_date_text").html( result[0].mbrshExprDt);
	});
}


function fn_goSalesConfirm(){
    
       if($("#SALES_PERSON").val() =="") {
		        
		        Common.alert("Please key in the collector code before you confirm the payment collector ");
		        return ;
		}
		    
		    
		Common.ajax("GET", "/sales/membership/paymentColleConfirm", { COLL_MEM_CODE:   $("#SALES_PERSON").val() } , function(result) {
		         console.log( result);
		         
		         if(result.length > 0){
		             
		             $("#SALES_PERSON").val(result[0].memCode);
		             $("#SALES_PERSON_DESC").html(result[0].name);
		             
		             $("#sale_confirmbt").attr("style" ,"display:none");
		             $("#sale_searchbt").attr("style" ,"display:none");
		             $("#sale_resetbt").attr("style" ,"display:inline");
		             $("#SALES_PERSON").attr("class","readonly");
		             
		         }else {
		             
		             $("#SALES_PERSON_DESC").html("");
		             Common.alert(" Unable to find [" +$("#SALES_PERSON").val() +"] in system. <br>  Please ensure you key in the correct member code.   ");
		             return ;
		         }
		         
		 });
} 

function  fn_goSalesPerson(){
	
	  Common.popupDiv("/sales/membership/paymentCollecter.do?resultFun=S");
} 


function fn_goSalesPersonReset(){

    $("#sale_confirmbt").attr("style" ,"display:inline");
    $("#sale_searchbt").attr("style" ,"display:inline");
    $("#sale_resetbt").attr("style" ,"display:none");
    $("#SALES_PERSON").attr("class","");
    $("#SALES_PERSON_DESC").html("");
    
}


function fn_doSalesResult(item){
	   
    if (typeof (item) != "undefined"){
            
           $("#SALES_PERSON").val(item.memCode);
           $("#SALES_PERSON_DESC").html(item.name);
           $("#sale_confirmbt").attr("style" ,"display:none");
           $("#sale_searchbt").attr("style" ,"display:none");
           $("#sale_resetbt").attr("style" ,"display:inline");
           $("#SALES_PERSON").attr("class","readonly");
           
    }else{
           $("#SALES_PERSON").val("");
           $("#SALES_PERSON_DESC").html("");
           $("#SALES_PERSON").attr("class","");
    }
}

</script>




 

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Membership Payment Convert to sale</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->



<!-- get param Form  -->
<form id="getParamForm" method="get">

<div  style="display:inline">
 ORD_ID:     <input type="text" name="ORD_ID"  id="ORD_ID"  value="${ORD_ID}"/>
 PAY_LAST_MBRSH_ID:     <input type="text" name="LAST_MBRSH_ID"  id="LAST_MBRSH_ID"  />
 
 </div>
    
</form>



<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1">
	<li><a href="#" class="on">Package Info</a></li>
	<li><a href="#">Order Info</a></li>
	<li><a href="#">Contact Info</a></li>
	<li><a href="#">Filter Charge Info</a></li>
</ul>

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:130px" />
	<col style="width:*" />
	<col style="width:130px" />
	<col style="width:*" />
	<col style="width:130px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Quotation No</th>
	<td><span id='convt_quotNo'>text</span></td>
	<th scope="row">Creator Date</th>
	<td><span  id='convt_cretDt' >text</span></td>
	<th scope="row">Create</th>
	<td><span  id='convt_create'  >text</span></td>
</tr>
<tr>
	<th scope="row">Membership Sales</th>
	<td><span  id='convt_sales'  >text</span></td>
	<th scope="row">Valid Date</th>
	<td colspan="3"><span id='convt_validDt'  >text</span></td>
</tr>
<tr>
	<th scope="row">Duration</th>
	<td><span id='convt_dur'  >text</span></td>
	<th scope="row">Package</th>
	<td colspan="3" id='convt_package'><span>text</span></td>
</tr>
<tr>
	<th scope="row">Total Amount</th>
	<td><span  id='convt_totAmt'>text</span></td>
	<th scope="row">Package Amount</th>
	<td><span id='convt_pakAmt'>text</span></td>
	<th scope="row">Filter Amount</th>
	<td><span id='convt_filterAmt'>text</span></td>
</tr>
<tr>
	<th scope="row">Package Promotion</th>
	<td colspan="5" id='convt_packPromo' ><span>text</span></td>
</tr>
<tr>
	<th scope="row">Filter Promotion</th>
	<td colspan="3" id='convt_filterPromo' ><span>text</span></td>
	<th scope="row">BS Frequency</th>
	<td><span  id='convt_bsFreq' >text</span></td>
</tr>
</tbody>
</table><!-- table end -->
</article><!-- tap_area end -->


<!-- oder info tab  start...-->
    <jsp:include page ='/sales/membership/inc_orderInfo.do?ORD_ID=${ORD_ID}'/> 
<!-- oder info tab  end...-->


<!-- person info tab  start...-->
    <jsp:include page ='/sales/membership/inc_contactPersonInfo.do'/> 
<!-- oder info tab  end...-->


<!-- person info tab  start...-->
    <jsp:include page ='/sales/membership/inc_quotFilterInfo.do'/> 
<!-- oder info tab  end...-->



<%--
<section class="search_table mt20"><!-- search_table start -->
<form action="#" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:170px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Reference Number</th>
	<td><input type="text" title="" placeholder="" class="" /></td>
</tr>
</tbody>
</table><!-- table end -->
</form>
</section><!-- search_table end -->
 --%>




<aside class="title_line"><!-- title_line start -->
<h3>Sales Person Information</h3>
</aside><!-- title_line end -->

<section class="search_table mt20"><!-- search_table start -->
<form action="#" method="post" id="salesForm" name="salesForm">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:170px" />
	<col style="width:*" />
	<col style="width:170px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Sales Person Code</th>
	<td><input type="text" title="" placeholder="" class="" id="SALES_PERSON" name="SALES_PERSON"  />
        <p class="btn_sky"  id="sale_confirmbt" ><a href="#" onclick="javascript:fn_goSalesConfirm()">Confirm</a></p>    
        <p class="btn_sky"  id="sale_searchbt"><a href="#" onclick="javascript:fn_goSalesPerson()" >Search</a></p>  
        <p class="btn_sky"  id="sale_resetbt"><a href="#" onclick="javascript:fn_goSalesPersonReset()" >Reset</a></p>
    </td>
	<th scope="row">Sales Person Code</th>
	<td><span id="SALES_PERSON_DESC"  name="SALES_PERSON_DESC"></span></td>
</tr>
</tbody>
</table><!-- table end -->
</form>
</section><!-- search_table end -->






<aside class="title_line"><!-- title_line start -->
<h3>Payment Information</h3>
</aside><!-- title_line end -->

<section class="search_table mt20"><!-- search_table start -->
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
<h3>Payment Collector Information</h3>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="collForm"  name="collForm">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:150px" />
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

 ---------------------   add on for Payment Item -----------------------------
 
 
<aside class="title_line"><!-- title_line start -->
<h3>Payment Item </h3>
</aside><!-- title_line end -->
 
 
 
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->



<script> 
    var quot = $("#QUOT_ID").val();
    console.log(quot);
    
    if(quot >0){ 
         fn_getMembershipQuotInfoAjax(); 
         fn_getMembershipQuotInfoFilterAjax();
         
    }else{
    	//auto로 넘어온 경우 
    	fn_getMembershipQuotInfoFilterAjax('${QUOT_ID}');
    }
</script>

