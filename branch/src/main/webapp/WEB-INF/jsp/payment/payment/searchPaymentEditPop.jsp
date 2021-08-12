<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javaScript">

//AUIGrid 그리드 객체
var viewHistoryGridID;
var viewPopMasterGridID;
var viewPopSlaveGridID;
var editPopGridID;

//Grid에서 선택된 RowID
var selectedGridValue;

var reconLock;

var payId = '${payId}';

//Grid Properties 설정
var gridPros = {
        editable : false,                 // 편집 가능 여부 (기본값 : false)
        showStateColumn : false     // 상태 칼럼 사용
};

// 화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
$(document).ready(function(){
    fn_openDivEditPop();

    //EDIT POP Branch Combo 생성
    doGetComboSepa('/common/selectBranchCodeList.do', '1' , ' - ' , '','edit_branchId', 'S' , '');
});

var popColumnLayout = [
     { dataField:"history" ,
         width: 30,
         headerText:" ",
         renderer : {
             type : "IconRenderer",
             iconTableRef :  {
                 "default" : "${pageContext.request.contextPath}/resources/images/common/search.png"// default
             },
             iconWidth : 16,
             iconHeight : 16,
             onclick : function(rowIndex, columnIndex, value, item) {
                 showDetailHistory2(item.payItmId);

             }
          }
     },
     { dataField:"payId" ,headerText:"",editable : false , visible : false },
     { dataField:"codeName" ,headerText:"<spring:message code='pay.head.mode'/>",editable : false},
     { dataField:"payItmRefNo" ,headerText:"<spring:message code='pay.head.refNo'/>",editable : false },
     { dataField:"c7" ,headerText:"<spring:message code='pay.head.cardType'/>",editable : false },
     { dataField:"payItmCcHolderName" ,headerText:"<spring:message code='pay.head.CCHolder'/>" ,editable : false },
     { dataField:"payItmCcExprDt" ,headerText:"<spring:message code='pay.head.CCExpiryDate'/>" ,editable : false },
     { dataField:"payItmCcNo" ,headerText:"<spring:message code='pay.head.CRCNo'/>" ,editable : false },
     { dataField:"payItmChqNo" ,headerText:"<spring:message code='pay.head.chequeNo'/>" ,editable : false },
     { dataField:"name" ,headerText:"<spring:message code='pay.head.issueBank'/>" ,editable : false },
     { dataField:"payItmAmt" ,headerText:"<spring:message code='pay.head.amount'/>" ,editable : false },
     { dataField:"c8" ,headerText:"<spring:message code='pay.head.CRCMode'/>" ,editable : false },
     { dataField:"accDesc" ,headerText:"<spring:message code='pay.head.bankAccount'/>" ,editable : false },
     { dataField:"payItmRefDt" ,headerText:"<spring:message code='pay.head.refDate'/>" ,editable : false , dataType : "date", formatString : "dd-mm-yyyy"},
     { dataField:"payItmAppvNo" ,headerText:"<spring:message code='pay.head.apprNo'/>" ,editable : false },
     { dataField:"payItmRem" ,headerText:"<spring:message code='pay.head.remark'/>" ,editable : false },
     { dataField:"c4" ,headerText:"<spring:message code='pay.head.eft'/>" ,editable : false },
     { dataField:"payItmRem" ,headerText:"<spring:message code='pay.head.runningNo'/>" ,editable : false },
     { dataField:"payItmBankChrgAmt" ,headerText:"<spring:message code='pay.head.bankCharge'/>" ,editable : false },
     { dataField:"payItmId" ,headerText:"<spring:message code='pay.head.payItemId'/>" ,editable : false, visible:false }
     ];

var popSlaveColumnLayout = [
    { dataField:"trxId" ,headerText:"<spring:message code='pay.head.trxNo'/>",editable : false},
    { dataField:"trxDt" ,headerText:"<spring:message code='pay.head.trxDate'/>",editable : false  },
    { dataField:"trxAmt" ,headerText:"<spring:message code='pay.head.trxTotal'/>",editable : false },
    { dataField:"payId" ,headerText:"<spring:message code='pay.head.PID'/>",editable : false },
    { dataField:"orNo" ,headerText:"<spring:message code='pay.head.ORNo'/>" ,editable : false },
    { dataField:"trNo" ,headerText:"<spring:message code='pay.head.TRNo'/>" ,editable : false },
    { dataField:"orAmt" ,headerText:"<spring:message code='pay.head.ORTotal'/>" ,editable : false },
    { dataField:"salesOrdNo" ,headerText:"<spring:message code='pay.head.orderNo'/>" ,editable : false },
    { dataField:"appTypeName" ,headerText:"<spring:message code='pay.head.appType'/>" ,editable : false },
    { dataField:"productDesc" ,headerText:"<spring:message code='pay.head.product'/>" ,editable : false },
    { dataField:"custName" ,headerText:"<spring:message code='pay.head.customer'/>" ,editable : false },
    { dataField:"custIc" ,headerText:"<spring:message code='pay.head.ICCONo'/>" ,editable : false },
    { dataField:"keyinBrnchName" ,headerText:"<spring:message code='pay.head.branch'/>" ,editable : false },
    { dataField:"keyinUserName" ,headerText:"<spring:message code='pay.head.userName'/>" ,editable : false }
    ];

var viewHistoryLayout=[
    { dataField:"typename" ,headerText:"<spring:message code='pay.head.type'/>" ,editable : false },
    { dataField:"valuefr" ,headerText:"<spring:message code='pay.head.from'/>" ,editable : false },
    { dataField:"valueto" ,headerText:"<spring:message code='pay.head.to'/>" ,editable : false },
    { dataField:"createdate" ,headerText:"<spring:message code='pay.head.updateDate'/>" ,editable : false, formatString : "dd-mm-yyyy" },
    { dataField:"creator" ,headerText:"<spring:message code='pay.head.updator'/>" ,editable : false }
    ];

var popEditColumnLayout = [
		{ dataField:"history" ,
		    width: 30,
		    headerText:" ",
		    colSpan : 2,
		   renderer :
		           {
		          type : "IconRenderer",
		          iconTableRef :  {
		              "default" : "${pageContext.request.contextPath}/resources/images/common/search.png"// default
		          },
		          iconWidth : 16,
		          iconHeight : 16,
		         onclick : function(rowIndex, columnIndex, value, item) {
		           showDetailHistory_E(item.payItmId, reconLock);
		         }
		       }
		},
		{ dataField:"history" ,
		    width: 30,
		    headerText:" ",
		    colSpan : -1,
		    renderer :
		           {
		          type : "IconRenderer",
		          iconTableRef :  {
		              "default" : "${pageContext.request.contextPath}/resources/images/common/modified_icon.png"// default
		          },
		          iconWidth : 16, // icon 가로 사이즈, 지정하지 않으면 24로 기본값 적용됨
		          iconHeight : 16,
		          onclick : function(rowIndex, columnIndex, value, item) {
		              showItemEdit(item.payItmId);
		         }
		       }
		},
		{ dataField:"payId" ,headerText:" ",editable : false , visible : false },
		{ dataField:"codeName" ,headerText:"<spring:message code='pay.head.mode'/>",editable : false},
		{ dataField:"payItmRefNo" ,headerText:"<spring:message code='pay.head.refNo'/>",editable : false },
		{ dataField:"c7" ,headerText:"<spring:message code='pay.head.cardType'/>",editable : false },
		{ dataField:"codeName1" ,headerText:"<spring:message code='pay.head.CCType'/>" ,editable : false },
		{ dataField:"codeName1" ,headerText:"<spring:message code='pay.head.CCType'/>" ,editable : false },
		{ dataField:"payItmCcHolderName" ,headerText:"<spring:message code='pay.head.CCHolder'/>" ,editable : false },
		{ dataField:"payItmCcExprDt" ,headerText:"<spring:message code='pay.head.CCExpiryDate'/>" ,editable : false },
		{ dataField:"payItmCcNo" ,headerText:"<spring:message code='pay.head.CRCNo'/>" ,editable : false },
		{ dataField:"payItmChqNo" ,headerText:"<spring:message code='pay.head.chequeNo'/>" ,editable : false },
		{ dataField:"name" ,headerText:"<spring:message code='pay.head.issueBank'/>" ,editable : false },
		{ dataField:"payItmAmt" ,headerText:"<spring:message code='pay.head.amount'/>" ,editable : false },
		{ dataField:"c8" ,headerText:"<spring:message code='pay.head.CRCMode'/>" ,editable : false },
		{ dataField:"accDesc" ,headerText:"<spring:message code='pay.head.bankAccount'/>" ,editable : false },
		{ dataField:"payItmRefDt" ,headerText:"<spring:message code='pay.head.refDate'/>" ,editable : false , dataType : "date", formatString : "dd-mm-yyyy"},
		{ dataField:"payItmAppvNo" ,headerText:"<spring:message code='pay.head.apprNo'/>" ,editable : false },
		{ dataField:"payItmRem" ,headerText:"<spring:message code='pay.head.remark'/>" ,editable : false },
		{ dataField:"c4" ,headerText:"<spring:message code='pay.head.eft'/>" ,editable : false },
		{ dataField:"payItmRunngNo" ,headerText:"<spring:message code='pay.head.runningNo'/>" ,editable : false },
		{ dataField:"payItmBankChrgAmt" ,headerText:"<spring:message code='pay.head.bankCharge'/>" ,editable : false },
		{ dataField:"payItmId" ,headerText:"<spring:message code='pay.head.payItemId'/>" ,editable : false, visible:false }
		];


function fn_openDivEditPop(){

          Common.ajax("GET", "/payment/selectPaymentDetailViewer.do", $("#editDetailForm").serialize(), function(result) {
        	  editPopGridID = GridCommon.createAUIGrid("editPopList_wrap", popEditColumnLayout, null, gridPros);

              //Payment Information
              $('#edit_txtORNo').text(result.viewMaster.orNo);$("#edit_txtORNo").css("color","red");
              $('#edit_txtLastUpdator').text(result.viewMaster.lastUpdUserName);$("#edit_txtLastUpdator").css("color","red");
              $('#edit_txtKeyInUser').text(result.viewMaster.keyinUserName);$("#edit_txtKeyInUser").css("color","red");
              $('#edit_txtOrderNo').text(result.viewMaster.salesOrdNo);$("#edit_txtOrderNo").css("color","red");
              $('#edit_txtTRRefNo').val(result.viewMaster.trNo);$("#edit_txtTRRefNo").css("backgroundColor","#F5F6CE");

              $("#edit_txtTRIssueDate").css("backgroundColor","#F5F6CE");
              var refDate = new Date(result.viewMaster.trIssuDt);
              var defaultDate = new Date("01/01/1900");
              if((refDate.getTime() > defaultDate.getTime())){
                  $("#edit_txtTRIssueDate").val(result.viewMaster.trIssuDt);
              }else{
                $("#edit_txtTRIssueDate").val("");
              }

              $('#edit_txtProductCategory').text(result.viewMaster.productCtgryName);
              $('#edit_txtProductName').text(result.viewMaster.productDesc);
              $('#edit_txtAppType').text(result.viewMaster.appTypeName);
              $('#edit_txtCustomerName').text(result.viewMaster.custName);
              $('#edit_txtCustomerType').text(result.viewMaster.custTypeName);
              $('#edit_txtCustomerID').text(result.viewMaster.custId);
              $('#edit_txtOrderProgressStatus').text(result.orderProgressStatus.name);
              $('#edit_txtInstallNo').text('');
              $('#edit_txtNRIC').text(result.viewMaster.custIc);
              $('#edit_txtPayType').text(result.viewMaster.payTypeName);
              $('#edit_txtAdvMth').text(result.viewMaster.advMonth);
              $('#edit_txtPayDate').text(result.viewMaster.payDt);
              $('#edit_txtHPCode').text(result.viewMaster.hpId);
              $('#edit_txtHPName').text(result.viewMaster.orNo);
              $('#edit_txtBatchPaymentID').text(result.viewMaster.batchPayId);

              //Collector Information
              $('#edit_txtSalesPerson').text(result.viewMaster.salesMemCode + "(" + result.viewMaster.salesMemName+")");
              $('#edit_txtBranch').text(result.viewMaster.clctrBrnchCode + "(" + result.viewMaster.clctrBrnchName+")");
              $('#edit_txtDebtor').text(result.viewMaster.debtorAccCode + "(" + result.viewMaster.debtorAccDesc+")");

              $('#edit_branchId').val(result.viewMaster.clctrBrnchId);
              $('#edit_txtCollectorCode').val(result.viewMaster.clctrCode);
              $('#edit_txtClctrName').text(result.viewMaster.clctrName);
              $('#edit_txtCollectorId').val(result.viewMaster.clctrId);

              if(result.viewMaster.allowComm != "1"){
                $("#btnAllowComm").prop('checked', false);

              }else{
                $("#btnAllowComm").prop('checked', true);
              }

              if(result.passReconSize  > 0 ){
                $("#edit_branchId").prop('disabled', true);
                reconLock = 1;
                $("#edit_branchId").css("backgroundColor","transparent");

              }else{
                $("#edit_branchId").prop('disabled', false);
                $("#edit_branchId").css("backgroundColor","#F5F6CE");
              }

              //팝업그리드 뿌리기
              AUIGrid.setGridData(editPopGridID, result.selectPaymentDetailView);

          });
}

function showViewHistory_E(){

	Common.popupDiv('/payment/initViewHistoryPop.do', {"payId":payId}, null , true);
}

function showDetailHistory_E(payItemId){
	Common.popupDiv('/payment/initDetailHistoryPop.do', {"payItemId":payItemId}, null , true);
}

function showItemEdit(payItemId){
	Common.popupDiv('/payment/initItemEditChequePop.do', {"payItemId":payItemId}, null , true);
}

function saveChanges() {

    var payId = $("#payId").val();
    var trNo = $("#edit_txtTRRefNo").val();
    var branchId = $("#edit_branchId").val();

    if($.trim(trNo).length > 10 ){
          Common.alert("<spring:message code='pay.alert.trNo'/>");
          return;
      }

    if($.trim(branchId ) == ""){
      Common.alert("<spring:message code='pay.alert.selectBranch'/>");
      return;
    }

    $("#hiddenPayId").val(payId);
    $("#hiddenBranchId").val(branchId);

    console.log("branchId :: " + branchId);
    console.log("hiddenBranchId :: " + $("#hiddenBranchId").val(branchId));

    Common.ajax("POST", "/payment/saveChanges", $('#myForm').serializeJSON(), function(result) {
          Common.alert(result.message);

    }, function(jqXHR, textStatus, errorThrown) {
          Common.alert("<spring:message code='pay.alert.failedUpdate'/>");
      });
 }

function fn_officialReceiptReport(){
      var selectedItem = AUIGrid.getSelectedIndex(myGridID);

      if (selectedItem[0] > -1){
          var orNo = AUIGrid.getCellValue(myGridID, selectedGridValue, "orNo");
          $("#reportPDFForm #v_ORNo").val(orNo);
          Common.report("reportPDFForm");

      }else{
          Common.alert("<spring:message code='pay.alert.noPay'/>");
     }
}

function  fn_goSalesPerson(){
	  Common.popupDiv("/sales/membership/paymentCollecter.do?resultFun=S");
}

function fn_doSalesResult(item){

      if (typeof (item) != "undefined"){

             $("#edit_txtCollectorCode").val(item.memCode);
             $("#edit_txtClctrName").html(item.name);
             $("#edit_txtCollectorId").val(item.memId);

             //$("#sale_confirmbt").attr("style" ,"display:none");
             //$("#sale_searchbt").attr("style" ,"display:none");
             //$("#sale_resetbt").attr("style" ,"display:inline");
             //$("#edit_txtCollectorCode").attr("class","readonly");

      }else{
             $("#edit_txtCollectorCode").val("");
			 $("#edit_txtClctrName").html("");
			 $("#edit_txtCollectorId").val("0");
             //$("#edit_txtCollectorCode").attr("class","");
      }
}

function fn_goSalesPersonReset(){

      //$("#sale_confirmbt").attr("style" ,"display:inline");
      //$("#sale_searchbt").attr("style" ,"display:inline");
      //$("#sale_resetbt").attr("style" ,"display:none");
	  $("#edit_txtCollectorCode").val("");
      $("#edit_txtClctrName").html("");
      $("#edit_txtCollectorId").val("0");
	  //$("#edit_txtCollectorCode").attr("class","");
}

function fn_goSalesConfirm(){

      if($("#edit_txtCollectorCode").val() =="") {

               Common.alert("<spring:message code='pay.alert.salesPersonCode'/>");
               return ;
       }

       Common.ajax("GET", "/sales/membership/paymentColleConfirm", { COLL_MEM_CODE:   $("#edit_txtCollectorCode").val() } , function(result) {
                if(result.length > 0){
                    $("#edit_txtCollectorCode").val(result[0].memCode);
                    $("#edit_txtClctrName").html(result[0].name);
                    $("#edit_txtCollectorId").val(result[0].memId);

                    //$("#sale_confirmbt").attr("style" ,"display:none");
                    //$("#sale_searchbt").attr("style" ,"display:none");
                    //$("#sale_resetbt").attr("style" ,"display:inline");
                    //$("#edit_txtCollectorCode").attr("class","readonly");

                }else {

					Common.alert(" Unable to find [" +$("#edit_txtCollectorCode").val() +"] in system. <br>  Please ensure you key in the correct member code.   ");

					$("#edit_txtCollectorCode").val("");
                    $("#edit_txtClctrName").html("");
                    $("#edit_txtCollectorId").val("0");
                    //$("#edit_txtCollectorCode").attr("class","");

                    return ;
                }

        });
}
</script>

<div id="edit_popup_wrap" class="popup_wrap" style="display:;">
  <!-- popup_wrap start -->
  <header class="pop_header"><!-- pop_header start -->
  <h1><spring:message code='pay.title.payEditor'/></h1>
  <ul class="right_opt">
      <li><p class="btn_blue2"><a href="#" onclick=""><spring:message code='sys.btn.close'/></a></p></li>
  </ul>
  </header><!-- pop_header end -->
  <form name="myForm" id="myForm">
  <section class="pop_body"><!-- pop_body start -->
      <aside class="title_line"><!-- title_line start -->
          <h2>Payment Information</h2>
      </aside><!-- title_line end -->
      <table class="type1"><!-- table start -->
          <caption>table</caption>
                  <colgroup>
                      <col style="width:165px" />
                      <col style="width:*" />
                      <col style="width:165px" />
                      <col style="width:*" />
                  </colgroup>
                  <tbody>
                      <tr>
                          <th scope="row">OR(Official Receipt) No</th>
                          <td id="edit_txtORNo"></td>
                          <th scope="row"> Last Updated By </th>
                          <td id="edit_txtLastUpdator"></td>
                      </tr>
                       <tr>
                          <th scope="row">Payment Key By</th>
                          <td id="edit_txtKeyInUser"></td>
                          <th scope="row">Order No.</th>
                          <td id="edit_txtOrderNo"></td>
                      </tr>
                      <tr>
                          <th scope="row">TR Ref. No.</th>
                          <td><input type="text" name="edit_txtTRRefNo" id="edit_txtTRRefNo"></td>
                          <th scope="row">TR Issued Date</th>
                          <td id="">
                              <div class="date_set"><!-- date_set start -->
                                  <p><input type="text"  name="edit_txtTRIssueDate" id="edit_txtTRIssueDate" title="Create Date From"  class="j_date" /></p>
                              </div>
                          </td>
                      </tr>
                       <tr>
                          <th scope="row">Product Category</th>
                          <td id="edit_txtProductCategory"></td>
                          <th scope="row">Product Name</th>
                          <td id="edit_txtProductName"></td>

                      </tr>
                      <tr>
                          <th scope="row">Application Type</th>
                          <td id="edit_txtAppType"></td>
                          <th scope="row">Customer Name</th>
                          <td id="edit_txtCustomerName"></td>

                      </tr>
                      <tr>
                          <th scope="row">Customer Type</th>
                          <td id="edit_txtCustomerType"></td>
                          <th scope="row"> Customer ID </th>
                          <td id="edit_txtCustomerID"></td>
                      </tr>
                      <tr>
                          <th scope="row">Order Progress Status</th>
                          <td id="edit_txtOrderProgressStatus"></td>
                          <th scope="row">Install No.</th>
                          <td id="edit_txtInstallNo"></td>
                      </tr>
                      <tr>
                          <th scope="row">Cust. NRIC/Company No.</th>
                          <td id="edit_txtNRIC"></td>
                          <th scope="row">Payment Type</th>
                          <td id="edit_txtPayType"></td>
                      </tr>
                      <tr>
                          <th scope="row">Advance Month</th>
                          <td id="edit_txtAdvMth"></td>
                          <th scope="row"> Payment Date </th>
                          <td id="edit_txtPayDate"></td>
                      </tr>
                      <tr>
                          <th scope="row">Branch Code</th>
                          <td id="" colspan="3">
                              <select id="edit_branchId" name="edit_branchId" class="w100p">
                               </select>
                          </td>
                      </tr>
                  </tbody>
      </table>
      <aside class="title_line"><!-- title_line start -->
          <h2>Collector Information</h2>
      </aside><!-- title_line end -->
      <table class="type1"><!-- table start -->
              <caption>table</caption>
                  <colgroup>
                      <col style="width:165px" />
                      <col style="width:*" />
                      <col style="width:165px" />
                      <col style="width:*" />
                  </colgroup>
                  <tbody>
                      <tr>
                          <th scope="row">Collector Code</th>
                          <td id="">
                              <input type="text" name="edit_txtCollectorCode" id="edit_txtCollectorCode" style="width:80px">
                              <p class="btn_sky"  id="sale_confirmbt" ><a href="#" onclick="javascript:fn_goSalesConfirm()"><spring:message code='pay.btn.confirm'/></a></p>
                              <p class="btn_sky"  id="sale_searchbt"><a href="#" onclick="javascript:fn_goSalesPerson()" ><spring:message code='sys.btn.search'/></a></p>
                              <p class="btn_sky"  id="sale_resetbt"><a href="#" onclick="javascript:fn_goSalesPersonReset()" >Remove</a></p>
                           </td>
                          <th scope="row">HP Code/Dealer</th>
                          <td id="edit_txtSalesPerson"></td>
                      </tr>
                       <tr>
                          <th scope="row">Collector Name</th>
                          <td id="edit_txtClctrName"></td>
                          <th scope="row">Debtor Account</th>
                          <td id="edit_txtDebtor"></td>
                      </tr>
                  </tbody>
      </table>
      <ul class="left_btns">
          <li><label><input name="btnAllowComm" id="btnAllowComm" type="checkbox"  /><span>Allow commission for this payment </span></label></li>
      </ul>
      <ul class="center_btns">
          <li><p class="btn_blue2"><a href="javascript:saveChanges()"><spring:message code='pay.btn.update'/></a></p></li>
          <li><p class="btn_blue2"><a href="javascript:showViewHistory_E()"><spring:message code='pay.btn.viewHistory'/></a></p></li>
      </ul>
      <section class="search_result"><!-- search_result start -->
          <article class="grid_wrap"  id="editPopList_wrap" style="width  : 100%;">
          </article><!-- grid_wrap end -->
      </section><!-- search_result end -->
  </section><!-- pop_body end -->
  <input type="hidden" name="hiddenPayId" id="hiddenPayId">
  <input type="hidden" name="hiddenBranchId" id="hiddenBranchId">
  <input type="hidden" name="allowComm" id="allowComm">
  <input type="hidden" name="edit_txtCollectorId"  id="edit_txtCollectorId" value="0"/>
  </form>
</div><!-- popup_wrap end -->

<!-- content end -->

<div id="view_history_wrap" class="popup_wrap size_small" style="display:none;">
    <header class="pop_header">
        <h1><spring:message code='pay.title.payMasHis'/></h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" onclick=""><spring:message code='sys.btn.close'/></a></p></li>
        </ul>
    </header>
    <!-- pop_body start -->
    <section class="pop_body">

        <!-- grid_wrap start -->
        <article id="grid_view_history" class="grid_wrap"></article>
        <!-- grid_wrap end -->
    </section>
    <!-- pop_body end -->
</div>

<div id="view_detail_wrap" class="popup_wrap size_small" style="display:none;">
    <header class="pop_header">
        <h1><spring:message code='pay.title.payDetsHis'/></h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" onclick=""><spring:message code='sys.btn.close'/></a></p></li>
        </ul>
    </header>
    <!-- pop_body start -->
    <section class="pop_body">

        <!-- grid_wrap start -->
        <article id="grid_detail_history" class="grid_wrap"></article>
        <!-- grid_wrap end -->
    </section>
    <!-- pop_body end -->
</div>
<!-- content end -->
<form name="editDetailForm" id="editDetailForm"  method="post">
    <input type="hidden" name="payId" id="payId" value="${payId}" />
    <input type="hidden" name="salesOrdId" id="salesOrdId" value="${salesOrdId}" />
    <input type="hidden" name="callPrgm" id="callPrgm" value="${callPrgm}" />
</form>
