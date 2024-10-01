<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>




<script type="text/javaScript" language="javascript">
    
var  gridID;

$(document).ready(function(){
	
    $("#table1").hide();
    
    if("${SESSION_INFO.userTypeId}" == "1" ||"${SESSION_INFO.userTypeId}" == "2" ){
        $("#table1").show();
    }

    if("${SESSION_INFO.memberLevel}" =="1"){

        $("#orgCode").val("${orgCode}");
        $("#orgCode").attr("class", "w100p readonly");
        $("#orgCode").attr("readonly", "readonly");
        
    }else if("${SESSION_INFO.memberLevel}" =="2"){

        $("#orgCode").val("${orgCode}");
        $("#orgCode").attr("class", "w100p readonly");
        $("#orgCode").attr("readonly", "readonly");
        
        $("#grpCode").val("${grpCode}");
        $("#grpCode").attr("class", "w100p readonly");
        $("#grpCode").attr("readonly", "readonly");
                    
    }else if("${SESSION_INFO.memberLevel}" =="3"){

        $("#orgCode").val("${orgCode}");
        $("#orgCode").attr("class", "w100p readonly");
        $("#orgCode").attr("readonly", "readonly");
        
        $("#grpCode").val("${grpCode}");
        $("#grpCode").attr("class", "w100p readonly");
        $("#grpCode").attr("readonly", "readonly");

        $("#deptCode").val("${deptCode}");
        $("#deptCode").attr("class", "w100p readonly");
        $("#deptCode").attr("readonly", "readonly");
                    
    }else if("${SESSION_INFO.memberLevel}" =="4"){
        
        $("#orgCode").val("${orgCode}");
        $("#orgCode").attr("class", "w100p readonly");
        $("#orgCode").attr("readonly", "readonly");
         
        $("#grpCode").val("${grpCode}");
        $("#grpCode").attr("class", "w100p readonly");
        $("#grpCode").attr("readonly", "readonly");

        $("#deptCode").val("${deptCode}");
        $("#deptCode").attr("class", "w100p readonly");
        $("#deptCode").attr("readonly", "readonly");

        $("#memCode").val("${memCode}");
        $("#memCode").attr("class", "w100p readonly");
        $("#memCode").attr("readonly", "readonly");
    }
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
        
          Common.alert("<spring:message code="sal.alert.msg.keyInMemNoOrdNoCrtDt" />");
              
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
        	   var st = $("#CRT_SDT").val().replace(/\//g,'');
               var ed = $("#CRT_EDT").val().replace(/\//g,'');
               
               var stDate = st.substring(4,8) +""+ st.substring(2,4) +""+ st.substring(0,2);
               var edDate = ed.substring(4,8) +""+ ed.substring(2,4) +""+ ed.substring(0,2);
                               
               if(stDate > edDate ){        	   
                    Common.alert("<spring:message code='commission.alert.dateGreaterCheck'/>", function(){
                        $("#CRT_EDT").focus();
                    });
                    return;
               }           
           }
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
                     {dataField :"qotatRefNo",  headerText : "<spring:message code="sal.title.quotationNo" />",      width: 110 ,editable : false },
                     {dataField :"salesOrdNo",  headerText : "<spring:message code="sal.title.ordNo" />",    width: 80, editable : false },
                     {dataField :"name", headerText : "<spring:message code="sal.title.custName" />",   width: 140, editable : false },
                     {dataField :"c2", headerText : "<spring:message code="sal.title.status" />",  width: 70, editable : false },
                     {dataField :"qotatValIdDt", headerText : "<spring:message code="sal.title.validDate" />",width: 90, dataType : "date", formatString : "dd-mm-yyyy"  ,editable : false },
                     {dataField :"srvCntrctPacDesc", headerText : "<spring:message code="sal.title.package" />", width: 150, editable : false },
                     {dataField :"qotatCntrctDur", headerText : "<spring:message code="sal.title.durationMth" />",width: 80, editable : false },
                     {dataField :"qotatCrtDt", headerText : "<spring:message code="sal.title.crtDate" />", width: 90,  dataType : "date", formatString : "dd-mm-yyyy" ,editable : false},
                     {dataField :"userName", headerText : "<spring:message code="sal.title.creator" />" , width: 130, editable : false }
          ];

           //그리드 속성 설정
         var gridPros = { usePaging : true,  pageRowCount: 20, editable: false, fixedColumnCount : 1,  headerHeight        : 30,  showRowNumColumn : true};  
           
           gridID = GridCommon.createAUIGrid("list_grid_wrap", columnLayout, "" ,gridPros);
       }
   
   

   function  fn_doViewQuotation(){
       
       var selectedItems = AUIGrid.getSelectedItems(gridID);
       
       if(selectedItems ==""){
           Common.alert("<spring:message code="sal.alert.noQuotationSelected" /> ");
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
       Common.alert("<spring:message code="sal.alert.noQuotationSelected" /> ");
       return ;
   }
   
   var v_stus = selectedItems[0].item.c2;
   var v_quotId = selectedItems[0].item.qotatId;
   var v_quotNo = selectedItems[0].item.qotatRefNo;
   
   
   if(v_stus !="ACT"){
	   Common.alert("<b>["+v_quotNo + "] <spring:message code="sal.alert.disallowed" /><b/>");
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
        return "<spring:message code="sal.text.convToSales" />";
    }else if(code =="DEA"){
        return "<spring:message code="sal.text.deactivated" />";
    }else if(code =="EXP"){
        return "<spring:message code="sal.text.wasExpired" />";
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
    
    $("text").each(function(){
        
        if($(this).hasClass("readonly")){           
        }else{
            $(this).val("");
        }
    });

    $("#STUS_ID").multipleSelect("uncheckAll");
}


function fn_doPrint(){
    
    var selectedItems = AUIGrid.getSelectedItems(gridID);
    
    if(selectedItems ==""){
           Common.alert("<spring:message code="sal.alert.noQuotationSelected" /> ");
           return ;
    }
    
    
    if("ACT" != selectedItems[0].item.c2 ){
          Common.alert("<spring:message code="sal.alert.msg.canNotPrint" />["+selectedItems[0].item.c2+"]");
        return ;
    }
      
    
    // 프로시져로 구성된 경우 꼭 아래 option을 넘겨야 함.
    var option = {
        isProcedure : true // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
    };
  
  
    $("#V_QUOTATIONID").val(selectedItems[0].item.qotatId);
    Common.report("reportInvoiceForm", option);
    
    }


function fn_updateStus(){
    
	Common.confirm("<spring:message code="sal.conf.deactivate" /> "+ $("#deActQotatRefNo").val() +"(orderNo." + $("#deActOrdNo").val() +")?",function(){
            
            Common.ajax("GET", "/sales/membershipRentalQut/updateStus", $("#listSForm").serialize(), function(result) {
                console.log( result);
                fn_selectListAjax();               

                $("#btnDeactive").hide();
           });
     });
     
}
 </script>
 
 <form id="reportInvoiceForm" method="post">
    <input type="hidden" id="reportFileName" name="reportFileName" value="/sales/ServiceContract_Quotation_PDF.rpt" />
    <input type="hidden" id="viewType" name="viewType" value="PDF" />
    <input type="hidden" id="V_QUOTATIONID" name="V_QUOTATIONID"  value=""/>
</form>
 

<section id="content"><!-- content start -->
<ul class="path">
	<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
	<li>Sales</li>
	<li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2><spring:message code="sal.page.title.rentalMembershipQuotationList" /></h2>
<ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_goNewQuotation()"><spring:message code="sal.btn.newQuotation" /></a></p></li>
    </c:if>
    <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_goConvertSale()"><spring:message code="sal.btn.convertToSale" /></a></p></li>
    </c:if>
    <c:if test="${PAGE_AUTH.funcView == 'Y'}">
 	<li><p class="btn_blue"><a href="#" onclick="javascript:fn_selectListAjax()"><span class="search"></span><spring:message code="sal.btn.search" /></a></p></li>
 	</c:if>
	<li><p class="btn_blue"><a href="#"  onclick="javascirpt:fn_clear()"><span class="clear"></span><spring:message code="sal.btn.clear" /></a></p></li>
</ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id='listSForm' name='listSForm'>
<input type="hidden" id="deActQotatId" name="srvCntrctQuotId" />
<input type="hidden" id="deActQotatRefNo" name="srvMemQuotNo" />
<input type="hidden" id="deActOrdNo" name="ordNo" />
<input id="pdpaMonth" name="pdpaMonth" type="hidden" value='${PAGE_AUTH.pdpaMonth}'/>

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
	<th scope="row"><spring:message code="sal.text.quotationNo" />  <span class="must">*</span></th>
	<td><input type="text" title="" placeholder="Quotation No."  id='QUOT_NO' name='QUOT_NO' class="w100p" /></td>
	<th scope="row"><spring:message code="sal.text.ordNo" />  <span class="must">*</span></th>
	<td><input type="text" title="" placeholder="Order No" class="w100p"  id='ORD_NO' name='ORD_NO'/></td>
	<th scope="row"><spring:message code="sal.text.status" /></th>
	<td>
		
		<select class="multy_select w100p" multiple="multiple" id="STUS_ID" name="STUS_ID">
	    </select>
	    
	    
	</td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.text.creator" /></th>
	<td><input type="text" title="" placeholder="Creator (Username)" class="w100p"   id='CRT_USER_ID' name='CRT_USER_ID'/></td>
	<th scope="row"><spring:message code="sal.text.createDate" />  <span class="must">*</span> </th>
	<td>
	<div class="date_set w100p"><!-- date_set start -->
	<p><input type="text"  placeholder="DD/MM/YYYY" id='CRT_SDT'   name='CRT_SDT'   class="j_date" /></p>
	<span><spring:message code="sal.text.to" /></span>
	<p><input type="text" placeholder="DD/MM/YYYY"  id='CRT_EDT' name='CRT_EDT'  class="j_date" /></p>
	</div><!-- date_set end -->
	</td>
	<th scope="row"></th>
	<td></td>
</tr>


<tr>
    <th scope="row" colspan="6" ><span class="must"> <spring:message code="sal.alert.msg.keyInMemNoOrdNoCrtDt" /></span>  </th>
</tr>

</tbody>
</table><!-- table end -->

<table class="type1"  id="table1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.orgCode" /></th>
    <td>
       <input type="text" title="" id="orgCode" name="orgCode" class="w100p" />
    </td>
    <th scope="row"><spring:message code="sal.text.grpCode" /></th>
    <td>
    <input type="text" title=""  id="grpCode"  name="grpCode" class="w100p" />
    </td>
    <th scope="row"><spring:message code="sal.text.detpCode" /></th>
    <td>
    <input type="text" title=""   id="deptCode" name="deptCode" class="w100p" />
    </td>
    <th scope="row"><spring:message code="sal.text.memberCode" /></th>
    <td>
    <input type="text" title=""   id="memCode" name="memCode" class="w100p" />
    </td>
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
		<c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
		<li><p class="link_btn"><a href="#" onclick="javascript:fn_doPrint()"><spring:message code="sal.btn.link.quotationDown" /></a></p></li>
		</c:if>
		<c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
		<li><p class="link_btn"><a href="#"  onclick="javascript:fn_doViewQuotation()"><spring:message code="sal.btn.link.viewQuotation" /></a></p></li>
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
<li><p class="btn_grid"><a href="#" id="btnDeactive" onclick="javascript:fn_updateStus()"><spring:message code="sal.btn.deactive" /></a></p></li>
</ul>



<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="list_grid_wrap" style="width:100%; height:360px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->

		