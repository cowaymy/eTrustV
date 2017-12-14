<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>




<script type="text/javaScript" language="javascript">
    
var  gridID;

$(document).ready(function(){ 
     createAUIGrid();
     
     AUIGrid.bind(gridID, "cellDoubleClick", function(event) {
         console.log(event.rowIndex);
         fn_doViewQuotation();
     });     

     $("#btnDeactive").hide();
     
     AUIGrid.bind(gridID, "cellClick", function(event) {
         console.log(event.rowIndex);
         
         if(AUIGrid.getCellValue(gridID, event.rowIndex, "c2") == "ACT"){
             $("#deActQotatId").val(AUIGrid.getCellValue(gridID, event.rowIndex, "qotatId") );
             $("#deActQotatRefNo").val(AUIGrid.getCellValue(gridID, event.rowIndex, "qotatRefNo") );
             $("#deActOrdNo").val(AUIGrid.getCellValue(gridID, event.rowIndex, "salesOrdNo") );
             $("#btnDeactive").show();
         }else{
             $("#deActQotatId").val("");
             $("#deActQotatRefNo").val("");
             $("#deActOrdNo").val("");
             $("#btnDeactive").hide();
         }
     });
     
     var optionUnit = {  
             id: "stusCodeId",              // 콤보박스 value 에 지정할 필드명.
             name: "codeName",  // 콤보박스 text 에 지정할 필드명.              
             isShowChoose: false,
             isCheckAll : false,
             type : 'M'
     };
     
     var selectValue = "1";
     
     CommonCombo.make('STUS_ID', "/status/selectStatusCategoryCdList.do", {selCategoryId : 22} , selectValue , optionUnit);
     
});
 

// 리스트 조회.
function fn_selectListAjax() {    

	

	   if( $("#QUOT_NO").val() ==""  &&  $("#ORD_NO").val() ==""  &&  $("#CRT_SDT").val() ==""  ){
	        
	          Common.alert("You must key-in at least one of Membership number / Order number / Creation date");
	              
	           return ;
	       }
	   
	
    Common.ajax("GET", "/sales/membershipRentalQut/quotationList", $("#listSForm").serialize(), function(result) {
         console.log( result);
         AUIGrid.setGridData(gridID, result);         

         $("#deActQotatId").val("");
         $("#deActQotatRefNo").val("");
         $("#deActOrdNo").val("");
    });
}
    
   
   
   function createAUIGrid() {
           var columnLayout = [ 
                     {dataField :"qotatId",  headerText : "",      width: 150 ,visible : false },
                     {dataField :"qotatRefNo",  headerText : "Quotation No",      width: 150 ,editable : false },
                     {dataField :"salesOrdNo",  headerText : "Order No",    width: 100, editable : false },
                     {dataField :"name", headerText : "Customer Name",   width: 150, editable : false },
                     {dataField :"c2", headerText : "Status",  width: 80, editable : false },
                     {dataField :"qotatValIdDt", headerText : "Valid Date",width: 100, dataType : "date", formatString : "dd-mm-yyyy"  ,editable : false },
                     {dataField :"srvCntrctPacDesc", headerText : "Package", width: 150, editable : false },
                     {dataField :"qotatCntrctDur", headerText : "Duration (Mth)",width: 80, editable : false },
                     {dataField :"qotatCrtDt", headerText : "Create Date", width: 100,  dataType : "date", formatString : "dd-mm-yyyy" ,editable : false},
                     {dataField :"userName", headerText : "Creator" , width: 150, editable : false }
          ];

           //그리드 속성 설정
         var gridPros = { usePaging : true,  pageRowCount: 20, editable: false, fixedColumnCount : 1,selectionMode : "singleRow",  showRowNumColumn : true};  
           
           gridID = GridCommon.createAUIGrid("list_grid_wrap", columnLayout, "" ,gridPros);
       }
   
   

   function  fn_doViewQuotation(){
       
       var selectedItems = AUIGrid.getSelectedItems(gridID);
       
       if(selectedItems ==""){
           Common.alert("No quotation selected. ");
           return ;
       }
       
       var pram  ="?QUOT_ID="+selectedItems[0].item.qotatId ; 
       Common.popupDiv("/sales/membershipRentalQut/mViewQuotation.do"+pram ,null, null , true , '_ViewQuotDiv1');
 }
   
   

   

 function  fn_goNewQuotation(){
        Common.popupDiv("/sales/membershipRentalQut/mNewQuotation.do" ,$("#listSForm").serialize(), null , true , '_NewQuotDiv1');
 }
   
   
 
function fn_goConvertSale(){

   var selectedItems = AUIGrid.getSelectedItems(gridID);
   
   if(selectedItems ==""){
       Common.alert("No quotation selected. ");
       return ;
   }
   
   var v_stus = selectedItems[0].item.c2;
   var v_quotId = selectedItems[0].item.qotatId;
   
   if(v_stus !="ACT"){
	   Common.alert("["+v_quotId + "] Convert this quotation to sales is disallowed.");
	   return false;
   }
   // status = expired면 접근불가 alert
   
//   var v_stus = selectedItems[0].item.validStus;
//   if(v_stus !="ACT" ){
//       Common.alert ("<b>[" + selectedItems[0].item.quotId + "] " + fn_getStatusActionByCode(v_stus) + ".<br />Convert this quotation to sales is disallowed.</b>");
//       return;
       
//   }else{
//       $("#QUOT_ID").val(selectedItems[0].item.quotId);
//       $("#ORD_ID").val(selectedItems[0].item.ordId);
       
       var pram  ="?QUOT_ID="+selectedItems[0].item.qotatId+"&ORD_ID="+selectedItems[0].item.qotatOrdId; 
       Common.popupDiv("/sales/membershipRentalQut/mRentalQuotConvSalePop.do"+pram);
//   }
 }
  
 

function fn_getStatusActionByCode(code){ 
    
    if( code =="CON"){
        return "has been converted to sales";
    }else if(code =="DEA"){
        return "has been deactivated";
    }else if(code =="EXP"){
        return "was expired";
    }else{
        return "";
    }
}


function fn_clear(){
    
    $("#QUOT_NO").val("");
    $("#ORD_NO").val("");
    $("#CRT_SDT").val("");
    $("#CRT_EDT").val("");
    $("#STUS_ID").val("");
    $("#CRT_USER_ID").val("");
}


function fn_doPrint(){
    
    var selectedItems = AUIGrid.getSelectedItems(gridID);
    
    if(selectedItems ==""){
           Common.alert("No quotation selected. ");
           return ;
    }
    
    
    if("1" != selectedItems[0].item.validStusId ){
          Common.alert("cat not print["+selectedItems[0].item.validStusId+"]");
        return ;
    }
      
    
    // 프로시져로 구성된 경우 꼭 아래 option을 넘겨야 함.
    var option = {
        isProcedure : true // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
    };
  
  
    $("#QUOTID").val(selectedItems[0].item.quotId);
    Common.report("reportInvoiceForm", option);
    
    }


function fn_updateStus(){
    
	Common.confirm("Are you sure you want to deactivate "+ $("#deActQotatRefNo").val() +"(orderNo." + $("#deActOrdNo").val() +")?",function(){
            
            Common.ajax("GET", "/sales/membershipRentalQut/updateStus", $("#listSForm").serialize(), function(result) {
                console.log( result);
                fn_selectListAjax();               

                $("#btnDeactive").hide();
           });
     });
     
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
<h2>Rental Membership - Quotation List</h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_goNewQuotation()">NEW Quotation</a></p></li>
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_goConvertSale()">Convert to Sale</a></p></li>
 	<li><p class="btn_blue"><a href="#" onclick="javascript:fn_selectListAjax()"><span class="search"></span>Search</a></p></li>
	<li><p class="btn_blue"><a href="#"  onclick="javascirpt:fn_clear()"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id='listSForm' name='listSForm'>
<input type="hidden" id="deActQotatId" name="srvCntrctQuotId" />
<input type="hidden" id="deActQotatRefNo" name="srvMemQuotNo" />
<input type="hidden" id="deActOrdNo" name="ordNo" />

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:130px" />
	<col style="width:*" />
	<col style="width:120px" />
	<col style="width:*" />
	<col style="width:120px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Quotation No  <span class="must">*</span></th>
	<td><input type="text" title="" placeholder="Quotation No."  id='QUOT_NO' name='QUOT_NO' class="w100p" /></td>
	<th scope="row">Order No  <span class="must">*</span></th>
	<td><input type="text" title="" placeholder="Order No" class="w100p"  id='ORD_NO' name='ORD_NO'/></td>
	<th scope="row">Status</th>
	<td>
		
		<select class="multy_select w100p" multiple="multiple" id="STUS_ID" name="STUS_ID">
	    </select>
	    
	    
	</td>
</tr>
<tr>
	<th scope="row">Creator</th>
	<td><input type="text" title="" placeholder="Creator (Username)" class="w100p"   id='CRT_USER_ID' name='CRT_USER_ID'/></td>
	<th scope="row">Create Date  <span class="must">*</span> </th>
	<td>
	<div class="date_set w100p"><!-- date_set start -->
	<p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" id='CRT_SDT'   name='CRT_SDT'   class="j_date" /></p>
	<span>To</span>
	<p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY"  id='CRT_EDT' name='CRT_EDT'  class="j_date" /></p>
	</div><!-- date_set end -->
	</td>
	<th scope="row"></th>
	<td></td>
</tr>


<tr>
    <th scope="row" colspan="6" ><span class="must"> You must key-in at least one of Membership number / Order number / Creation date</span>  </th>
</tr>

</tbody>
</table><!-- table end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
	<dt>Link</dt>
	<dd>
	<ul class="btns">
		
	</ul>
	<ul class="btns">
		<li><p class="link_btn type2"><a href="#" onclick="javascript:fn_doPrint()">Quotation Download</a></p></li>
		<li><p class="link_btn type2"><a href="#"  onclick="javascript:fn_doViewQuotation()">View Quotation</a></p></li>
	</ul>
	<p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
	</dd>
</dl>
</aside><!-- link_btns_wrap end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->


<ul class="right_btns">
<li><p class="btn_grid"><a href="#" id="btnDeactive" onclick="javascript:fn_updateStus()">Deactive</a></p></li>
</ul>



<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="list_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->

		