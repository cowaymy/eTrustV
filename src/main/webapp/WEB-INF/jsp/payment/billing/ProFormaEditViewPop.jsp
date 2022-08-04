<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
  $(document).ready(function() {

	  createProFormaAUIGrid();
	  fn_viewType("${viewType}");
	  fn_stusOnchange();
	  fn_getProFormaDetail();
  });

  function  fn_viewType(type){
	  if (type == 1){ //View
		  $('#sForm').hide();
          $('#btn_save').hide();
          $('#btn_clear').hide();
	  }

	  if (type == 2){ //Edit
		  $('#sForm').show();
          $('#btn_save').show();
          $('#btn_clear').show();
      }
  }

  function fn_stusOnchange(){
	  if ($("#sForm #listproFormaStatus").val() == 81) { //CONVERTED
          $("#discPeriod").show();
          $("#advRental").show();
      }
      else {
          $("#discPeriod").hide();
          $("#advRental").hide();
      }
  }

  function createProFormaAUIGrid() {
      var columnLayoutProForma = [
                {dataField :"proFormaId",  headerText : "proFormaId", width: 140 ,editable : false, visible : false},
                {dataField :"salesOrdId",  headerText : "SalesOrdId", width: 140 ,editable : false, visible : false},
                {dataField :"salesOrdNo", headerText : "salesOrdNo",   width: 100,editable : false, visible : false },
                {dataField :"refNo", headerText : "Ref No",   width: 100, editable : false  },
                {dataField :"custName",  headerText : "<spring:message code="pay.head.customerName" />",      width: 150 ,editable : false },
                {dataField :"mthRentAmt",  headerText : "<spring:message code="sal.title.text.finalRentalFees" />",      width: 100 ,editable : false },
                {dataField :"packType",  headerText : "<spring:message code="pay.head.package" />",    width: 100, editable : false },
                {dataField :"discPeriod", headerText : "<spring:message code="pay.head.discountPeriod" />",  width: 100, editable : false },
                {dataField :"advPeriod", headerText : "Advance Period",  width: 150, editable : false },
                {dataField :"packPrice", headerText : "<spring:message code="sal.text.packPrice" />",  width: 150, editable : false }
     ];

      //그리드 속성 설정
    var proFormaGridPros = {
              usePaging : true,
              pageRowCount: 10,
              editable: false,
              fixedColumnCount : 1,
              headerHeight     : 30,
              height : 200,
              showRowNumColumn : true};

      proFormaGridID = GridCommon.createAUIGrid("proForma_grid_wrap", columnLayoutProForma, "" ,proFormaGridPros);
  }

  function fn_getProFormaDetail() {
      Common.ajax("GET", "/payment/searchProFormaInvoiceList.do", { proFormaId : '${proFormaId}'}, function(result) {
    	  console.log("ahhhhhh");
    	  console.log(result);

    	  $("#salesOrdNo").html(result[0].salesOrdNo);
          $("#customerName").html(result[0].custName);
          $("#typePack").html(result[0].packType);
          $("#salesmanCode").html(result[0].salesmanCode);
          $("#discount").val(result[0].discPeriod);
          $("#advStartDt").val(result[0].advStartDt);
          $("#advEndDt").val(result[0].advEndDt);

          AUIGrid.setGridData(proFormaGridID, result);
      });
  }

  function fn_doSaveEdit(){

      Common.ajax("POST", "/payment/farCheckConvertFn.do", { proFormaId : '${proFormaId}', stusId: $("#listproFormaStatus").val(), orderNo : $("#ORD_NO").val()},
              function(result) {
                Common.alert(result.message, fn_saveclose);
                $("#popup_wrap").remove();
                fn_selectListAjax();
    });
  }

  function fn_saveclose() {
      editViewProFormaPopupId.remove();
  }

</script>
<div id="popup_wrap" class="popup_wrap">
 <!-- popup_wrap start -->
 <section id="content">
  <!-- content start -->
  <form id="proFormaForm" method="post">
   <div style="display: none">
    <input type="text" name="ORD_ID" id="ORD_ID" value="${ORD_ID}" />
    <input type="text" name="ORD_NO" id="ORD_NO" value="${ORD_NO}" />
    <input type="text" name="refNo" id="refNo" value="${refNo}" />
    <input type="text" name="proFormaId" id="proFormaId" value="${proFormaId}" />
    <input type="text" name="viewType" id="viewType" value="${viewType}" />
   </div>
  </form>
  <header class="pop_header">
   <!-- pop_header start -->
   <h1>
    <spain id='title_spain'>
    <c:if test="${viewType eq  '1' }"> <spring:message code='pay.btn.link.viewDetails' /></c:if>
    <c:if test="${viewType eq  '2' }"> <spring:message code='service.title.addResp' /></c:if>
    </spain>
   </h1>
   <ul class="right_opt">
    <li><p class="btn_blue2">
      <a href="#"><spring:message code='sys.btn.close' /></a>
     </p></li>
   </ul>
  </header>
  <!-- pop_header end -->
  <section class="pop_body">
   <!-- pop_body start -->
   <section class="tap_wrap">
    <!-- tap_wrap start -->
    <ul class="tap_type1">
      <li><a href="#" class="on">Pro Forma Detail</a></li>
      <li><a href="#"><spring:message code='sal.tap.title.ordInfo' /></a></li>
    </ul>

    <!--Proforma Detail start-->
    <article class="tap_area">
	    <table class="type1">
	     <!-- table start -->
	     <caption>table</caption>
	     <colgroup>
	         <col style="width: 130px" />
             <col style="width: 100px" />
             <col style="width: 170px" />
             <col style="width: *" />
	     </colgroup>
	     <tbody>
	      <tr>
		       <th scope="row"><spring:message code='service.title.OrderNo' /></th>
		       <td><span id="salesOrdNo"></td>
		       <th scope="row"><spring:message code='pay.head.customerName' /></th>
		       <td><span id="customerName"></td>
	      </tr>
	      <tr>
	       <th scope="row"><spring:message code='sal.text.typeOfPack' /></th>
	       <td id="typePack"></td>
	       <th scope="row"><spring:message
	         code='sal.text.salPersonCode' /></th>
	       <td id="salesmanCode"></td>
	      </tr>
	     </tbody>
	    </table>

	     <article class="grid_wrap"><!-- grid_wrap start -->
            <div id="proForma_grid_wrap" style="width:100%; height:100%; margin:0 auto;"></div>
        </article>
   </article>

   <!--Pro Forma Info end-->
    <article class="tap_area">
       <!------------------------------------------------------------------------------
          Order Detail Page Include START
         ------------------------------------------------------------------------------->
         <%@ include file="/WEB-INF/jsp/sales/order/orderDetailContent.jsp"%>
       <!------------------------------------------------------------------------------
          Order Detail Page Include END
         ------------------------------------------------------------------------------->
     </article>
     <!-- tap_area end -->
   </section>
   <!-- tap_wrap end -->
   </article>
   <section>
    <br>

<form action="#"   id="sForm"  name="saveForm" method="post"   onsubmit="return false;">

        <section class="search_table"><!-- search_table start -->
        <form action="#" method="post"  id='collForm' name ='collForm'>

        <table class="type1"><!-- table start -->
        <caption>table</caption>
        <colgroup>
             <col style="width: 130px" />
             <col style="width: 350px" />
             <col style="width: 170px" />
             <col style="width: *" />
        </colgroup>
        <tbody>
        <tr>
            <th scope="row"><spring:message code='pay.head.Status'/></th>
            <td>
		        <select id="listproFormaStatus" name="proFormaStatus" class="w100p" onchange="fn_stusOnchange()">
		               <option value="1">Active</option><!--ProForma request submitted-->
		               <option value="44">Pending</option><!--pending payment-->
		               <option value="36">Closed</option><!--ProForma without payment-->
		               <option value="81">Converted</option><!--ProFo rma convert to bill-->
		               <option value="10">Cancelled</option><!--invoice been generate-->
		        </select>
		    </td>
            <th scope="row"></th><td></td>
        </tr>
        <aside class="title_line"><!-- title_line start -->
            <h3>Update <spring:message code="pay.head.discountPeriod" /></h3>
        </aside><!-- title_line end -->
        <tr id="discPeriod">

            <th scope="row"><spring:message code="pay.head.discountPeriod" /></th>
            <td>
            <select  id="discount"   name= "discount" disabled="disabled" readonly="readonly">
                <option value="12" >1</option>
                <option value="24" >2</option>
            </select>
            <th scope="row"></th><td></td>
        </tr>
        <tr  id="advRental">
            <th scope="row">Advance Period</th>
            <td>
                <div class="date_set w100p"><!-- date_set start -->
                <p><input type="text"  placeholder="DD/MM/YYYY" class="j_date2 w100p" id="advStartDt"  name="startDt" disabled="disabled" readonly="readonly" /></p>
                <span><spring:message code="sal.text.to" /></span>
                <p><input type="text"  placeholder="DD/MM/YYYY" class="j_date2 w100p" id="advEndDt"  name="endDt" disabled="disabled" readonly="readonly" /></p>
                </div><!-- date_set end -->
            </td>
            <th scope="row"></th><td></td>
        </tr>
        </tbody>
        </table><!-- table end -->
        </form>
        </section><!-- search_table end -->
	</form>
	</section>

   <!-- acodi_wrap end -->
   <div id='btnSaveDiv'>
   <ul class="center_btns mt20">
    <li><p class="btn_blue2 big">
      <a href="#" id="btn_save" onclick="fn_doSaveEdit()"><spring:message code='sys.btn.save' /></a>
     </p></li>
   </ul>
   </div>
  </section>
  <!-- content end -->
 </section>
 <!-- content end -->
</div>
<!-- popup_wrap end -->
