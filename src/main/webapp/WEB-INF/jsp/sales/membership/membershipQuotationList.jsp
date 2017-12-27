<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>




<script type="text/javaScript" language="javascript">
    
    //AUIGrid 생성 후 반환 ID
    var  gridID;

    
    $(document).ready(function(){
        createAUIGrid();       

        $("#btnDeactive").hide();
        
        AUIGrid.bind(gridID, "cellDoubleClick", function(event) {
            console.log(event.rowIndex);
            fn_doViewQuotation();
        });
        
        AUIGrid.bind(gridID, "cellClick", function(event) {
            console.log(event.rowIndex);
            
            if(AUIGrid.getCellValue(gridID, event.rowIndex, "validStus") == "ACT"){
                $("#deActQuotNo").val(AUIGrid.getCellValue(gridID, event.rowIndex, "quotNo") );
                $("#deActOrdNo").val(AUIGrid.getCellValue(gridID, event.rowIndex, "ordNo") );
                $("#btnDeactive").show();
            }else{
                $("#deActQuotNo").val("");
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
        
        var selectValue = "1" + DEFAULT_DELIMITER + "81";
        
        CommonCombo.make('VALID_STUS_ID', "/status/selectStatusCategoryCdList.do", {selCategoryId : 22} , selectValue , optionUnit);
        
    });
    
    
    // 리스트 조회.
   function fn_selectListAjax() {        
    	
    	
	   AUIGrid.refreshRows() ;
    	if( $("#QUOT_NO").val() ==""  &&  $("#L_ORD_NO").val() ==""  &&  $("#CRT_SDT").val() ==""  ){
    	 Common.alert("You must key-in at least one of Membership number / Order number / Creation date");
    		return ;
    	}
    	
   	   if($("#CRT_EDT").val() !=""){
   	        if($("#CRT_SDT").val()==""){
   	             var msg = '<spring:message code="sales.CreateDate" />';
   	                Common.alert("<spring:message code='sys.common.alert.validation' arguments='"+msg+"' htmlEscape='false'/>", function(){
   	                    $("#CRT_SDT").focus();
   	                });
   	                return;
   	        }else{
   	            if($("#CRT_SDT").val() >   $("#CRT_EDT").val() ){
   	                 Common.alert("<spring:message code='commission.alert.dateGreaterCheck'/>", function(){
   	                     $("#CRT_EDT").focus();
   	                 });
   	                 return;
   	            }           
   	        }
   	    }
    	
       Common.ajax("GET", "/sales/membership/quotationList", $("#listSForm").serialize(), function(result) {
            console.log( result);
	        AUIGrid.setGridData(gridID, result);
       });       

       $("#deActQuotNo").val("");
   }
    
   
   
   function createAUIGrid() {
           var columnLayout = [ 
                     {dataField :"quotNo",  headerText : "Quotation No",      width: 100 ,editable : false },
                     {dataField :"ordNo",  headerText : "Order No",    width: 70, editable : false },
                     {dataField :"custName", headerText : "Customer Name",   width: 140, editable : false },
                     {dataField :"validStus", headerText : "Status",  width: 60, editable : false },
                     {dataField :"hasbill", headerText : "HasBill" , width: 60, editable : false ,
                         renderer : {
                             type : "CheckBoxEditRenderer",
                             editable : false, // 체크박스 편집 활성화 여부(기본값 : false)
                             checkValue : "1"  
                         }
                     },
                     {dataField :"validDt", headerText : "Valid Date",width: 90, dataType : "date", formatString : "dd-mm-yyyy"  ,editable : false },
                     {dataField :"pacDesc", headerText : "Package", width: 140, editable : false },
                     {dataField :"dur", headerText : "Duration</br>(Mth)",width: 75, editable : false },
                     {dataField :"crtDt", headerText : "Create Date", width: 90,  dataType : "date", formatString : "dd-mm-yyyy" ,editable : false},
                     {dataField :"crtUserId", headerText : "Package" , width: 120, editable : false }
                    
          ];

           //그리드 속성 설정
         var gridPros = { usePaging : true,  pageRowCount: 20, editable: false, fixedColumnCount : 1,selectionMode : "singleRow",              
                 headerHeight        : 30,       showRowNumColumn : true};  
           
           gridID = GridCommon.createAUIGrid("list_grid_wrap", columnLayout, "" ,gridPros);
       }
   
   

   function  fn_doViewQuotation(){
       
       var selectedItems = AUIGrid.getSelectedItems(gridID);
       
       if(selectedItems ==""){
           Common.alert("No quotation selected. ");
           return ;
       }
       
       $("#MBRSH_ID").val(selectedItems[0].item.memId);
       $("#QUOT_ID").val(selectedItems[0].item.quotId);
       var pram  ="?QUOT_ID="+selectedItems[0].item.quotId+"&ORD_ID="+selectedItems[0].item.ordId+"&CNT_ID="+selectedItems[0].item.cntId +"&MBRSH_ID="+selectedItems[0].item.memId; 
       Common.popupDiv("/sales/membership/mViewQuotation.do"+pram ,null, null , true , '_ViewQuotDiv1');
 }
   
   

   

 function  fn_goNewQuotation(){
	    Common.popupDiv("/sales/membership/mNewQuotation.do" ,$("#listSForm").serialize(), null , true , '_NewQuotDiv1');
 }
   
   
 
function fn_goConvertSale(){

   var selectedItems = AUIGrid.getSelectedItems(gridID);
   
   if(selectedItems ==""){
       Common.alert("No quotation selected. ");
       return ;
   }
   
   var v_stus = selectedItems[0].item.validStus;
   if(v_stus !="ACT" ){
	   Common.alert ("<b>[" + selectedItems[0].item.quotId + "] " + fn_getStatusActionByCode(v_stus) + ".<br />Convert this quotation to sales is disallowed.</b>");
	   return;
	   
   }else{
	   $("#QUOT_ID").val(selectedItems[0].item.quotId);
	   $("#ORD_ID").val(selectedItems[0].item.ordId);
	   $("#PAY_ORD_ID").val(selectedItems[0].item.ordId);
	   $("#MBRSH_ID").val(selectedItems[0].item.memId);
	   
	   
	   var pram  ="?QUOT_ID="+selectedItems[0].item.quotId+"&ORD_ID="+selectedItems[0].item.ordId +"&MBRSH_ID="+selectedItems[0].item.memId; 
	   Common.popupDiv("/sales/membership/mConvSale.do"+pram,null, null , true , '_mConvSaleDiv1');
       
   }
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
	
	$("#CRT_USER_ID").val("");
	$("#CRT_EDT").val("");
	$("#CRT_SDT").val("");
	$("#L_ORD_NO").val("");
	$("#QUOT_NO").val("");
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
  
  
    $("#V_QUOTID").val(selectedItems[0].item.quotId);
    Common.report("reportInvoiceForm", option);
    
    }
    
    function fn_updateStus(){
        
    	Common.confirm("Are you sure you want to deactivate "+ $("#deActQuotNo").val() +"(orderNo." + $("#deActOrdNo").val() +")?",function(){
    		
    			Common.ajax("GET", "/sales/membership/updateStus", $("#listSForm").serialize(), function(result) {
		            console.log( result);
		            fn_selectListAjax();

		            $("#btnDeactive").hide();
		       });
		 });
         
    }
    
 </script>
 
 
 
 
<form id="reportInvoiceForm" method="post">
    <input type="hidden" id="reportFileName" name="reportFileName" value="/membership/MembershipQuotation_20150401.rpt" />
    <input type="hidden" id="viewType" name="viewType" value="PDF" />
    <input type="hidden" id="V_QUOTID" name="V_QUOTID"  value=""/>
</form>


<form id="getParamForm" method="post">

<div style="display:none">
    <input type="text" name="QUOT_ID"  id="QUOT_ID" />
    
    <!-- <input type="text" name="ORD_ID"  id="ORD_ID" /> -->
    <input type="text" name="MBRSH_ID"  id="MBRSH_ID" />
    
    <!-- Last Membership data -->
     <input type="text" name="PAY_ORD_ID"    id="PAY_ORD_ID" />  
     <input type="text" name="PAY_LAST_MBRSH_ID"      id="PAY_LAST_MBRSH_ID"  />  
    <!-- Last Membership data -->
       
       
</div>
</form>
 
 
 
<section id="content"><!-- content start -->
<ul class="path">
	<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
	<li>Sales</li>
	<li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Outright Membership - Quotation List </h2>


<ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_goNewQuotation()">NEW Quotation</a></p></li>
    </c:if>
    <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_goConvertSale()">Convert to Sale</a></p></li>
    </c:if>
    <c:if test="${PAGE_AUTH.funcView == 'Y'}">
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_selectListAjax()"><span class="search"></span>Search</a></p></li>
    </c:if>
	<li><p class="btn_blue"><a href="#" onclick="javascript:fn_clear()"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id='listSForm' name='listSForm'>
<input type="hidden" id="deActQuotNo" name="srvMemQuotNo" />
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
	<th scope="row">Quotation No   <span class="must">*</span></th>
	<td>
	<input type="text" title="" placeholder="Quotation Number" class="w100p"  id="QUOT_NO"  name="QUOT_NO"  />

	</td>
	<th scope="row">Order No <span class="must">*</span> </th>
	<td>
	<input type="text" title="" placeholder="Order Number" class="w100p"   id="L_ORD_NO"  name="L_ORD_NO"/>   
	</td>
	<th scope="row">Create Date <span class="must">*</span></th>
	<td>

	<div class="date_set w100p"><!-- date_set start -->
	<p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date"  id="CRT_SDT"  name="CRT_SDT" /></p>
	<span>To</span>
	<p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date"   id="CRT_EDT"  name="CRT_EDT"/></p>
	</div><!-- date_set end -->

	</td>
</tr>
<tr>
	<th scope="row">Creator</th>
	<td>
	<input type="text" title="" placeholder="Creator (Username)" class="w100p"  id="CRT_USER_ID"  name="CRT_USER_ID"/>
	</td>
	<th scope="row">Status</th>
	<td>
	<select class="multy_select w100p" multiple="multiple" id="VALID_STUS_ID" name="VALID_STUS_ID">
	</select>
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
		<c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
		<li><p class="link_btn"><a href="#" onclick="javascript:fn_doPrint()">Quotation Download</a></p></li>
		</c:if>
		<c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
		<li><p class="link_btn"><a href="#"  onclick="javascript:fn_doViewQuotation()">View Quotation</a></p></li>
		</c:if>
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
    <div id="list_grid_wrap" style="width:100%; height:360px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->

