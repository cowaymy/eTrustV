<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javaScript">

//AUIGrid 그리드 객체
var viewHistoryGridID_V;
var viewPopMasterGridID_V;
var viewPopSlaveGridID_V;


//Grid에서 선택된 RowID
var selectedGridValue;

//Grid Properties 설정 
var gridPros = {            
        editable : false,                 // 편집 가능 여부 (기본값 : false)
        showStateColumn : false     // 상태 칼럼 사용
};

// 화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
$(document).ready(function(){
    fn_openDivViewPop();

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
                 showViewDetailHistory_V(item.payItmId);
                 
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


function fn_openDivViewPop(){
          
          Common.ajax("GET", "/payment/selectPaymentDetailViewer.do", $("#viewDetailForm").serialize(), function(result) {

              viewPopMasterGridID_V = GridCommon.createAUIGrid("popList_wrap", popColumnLayout,null,gridPros);
              viewPopSlaveGridID_V = GridCommon.createAUIGrid("popSlaveList_wrap", popSlaveColumnLayout,null,gridPros);
              console.log(result);
              //Payment Information
              $('#txtORNo').text(result.viewMaster.orNo);$("#txtORNo").css("color","red");
              $('#txtLastUpdator').text(result.viewMaster.lastUpdUserName);$("#txtLastUpdator").css("color","red");
              $('#txtKeyInUser').text(result.viewMaster.keyinUserName);$("#txtKeyInUser").css("color","red");
              $('#txtOrderNo').text(result.viewMaster.salesOrdNo);$("#txtOrderNo").css("color","red");
              $('#txtTRRefNo').text(result.viewMaster.trNo);
              $('#txtTRIssueDate').text(result.viewMaster.trIssuDt);
              $('#txtProductCategory').text(result.viewMaster.productCtgryName);
              $('#txtProductName').text(result.viewMaster.productDesc);
              $('#txtAppType').text(result.viewMaster.appTypeName);
              $('#txtCustomerName').text(result.viewMaster.custName);
              $('#txtCustomerType').text(result.viewMaster.custTypeName);
              $('#txtCustomerID').text(result.viewMaster.custId);
              if(result.orderProgressStatus.name != null){
                $('#txtOrderProgressStatus').text(result.orderProgressStatus.name);
              }else{
                $('#txtOrderProgressStatus').text("");
              }
              
              $('#txtInstallNo').text('');
              $('#txtNRIC').text(result.viewMaster.custIc);
              $('#txtPayType').text(result.viewMaster.payTypeName);
              $('#txtAdvMth').text(result.viewMaster.advMonth);
              $('#txtPayDate').text(result.viewMaster.payDt);
              $('#txtHPCode').text(result.viewMaster.hpCode);
              $('#txtHPName').text(result.viewMaster.hpName);
              $('#txtBatchPaymentID').text(result.viewMaster.batchPayId);
               
              //Collector Information
              $('#txtCollectorCode').text(result.viewMaster.clctrCode);
              $('#txtSalesPerson').text(result.viewMaster.salesMemCode + "(" + result.viewMaster.salesMemName+")");
              $('#txtBranch').text(result.viewMaster.clctrBrnchCode + "(" + result.viewMaster.clctrBrnchName+")");
              $('#txtDebtor').text(result.viewMaster.debtorAccCode + "(" + result.viewMaster.debtorAccDesc+")");
              $("#gridTitle").css("color","red");
              
              //팝업그리드 뿌리기
              AUIGrid.setGridData(viewPopMasterGridID_V, result.selectPaymentDetailView);
              AUIGrid.setGridData(viewPopSlaveGridID_V, result.selectPaymentDetailSlaveList);
              
          });
}

function showViewDetailHistory_V(payItemId){
	  Common.popupDiv('/payment/initDetailHistoryPop.do', {"payItemId":payItemId}, null , true);
}

function showViewHistory_V(){
	  Common.popupDiv('/payment/initViewHistoryPop.do', {"payId":$("#payId").val()}, null , true);
}

</script>

<div id="view_popup_wrap" class="popup_wrap" style="display:;">
  <!-- popup_wrap start -->
  <header class="pop_header"><!-- pop_header start -->
    <h1><spring:message code='pay.title.viewPayDets'/></h1>
    <ul class="right_opt">
        <li><p class="btn_blue2"><a href="#" onclick="" id="_viewClose"><spring:message code='sys.btn.close'/></a></p></li>
    </ul>
  </header><!-- pop_header end -->
  
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
                          <td id="txtORNo"></td>
                          <th scope="row"> Last Updated By </th>
                          <td id="txtLastUpdator"></td>
                      </tr>
                       <tr>
                          <th scope="row">Payment Key By</th>
                          <td id="txtKeyInUser"></td>
                          <th scope="row">Order No.</th>
                          <td id="txtOrderNo"></td>
                      </tr>
                      <tr>
                          <th scope="row">TR Ref. No.</th>
                          <td id="txtTRRefNo"></td>
                          <th scope="row">TR Issued Date</th>
                          <td id="txtTRIssueDate"></td>
                      </tr>
                       <tr>
                          <th scope="row">Product Category</th>
                          <td id="txtProductCategory"></td>
                          <th scope="row">Product Name</th>
                          <td id="txtProductName"></td>
                          
                      </tr>
                      <tr>
                          <th scope="row">Application Type</th>
                          <td id="txtAppType"></td>
                          <th scope="row">Customer Name</th>
                          <td id="txtCustomerName"></td>
                          
                      </tr>
                      <tr>
                          <th scope="row">Customer Type</th>
                          <td id="txtCustomerType"></td>
                          <th scope="row"> Customer ID </th>
                          <td id="txtCustomerID"></td>
                      </tr>
                      <tr>
                          <th scope="row">Order Progress Status</th>
                          <td id="txtOrderProgressStatus"></td>
                          <th scope="row">Install No.</th>
                          <td id="txtInstallNo"></td>
                      </tr>
                      <tr>
                          <th scope="row">Cust. NRIC/Company No.</th>
                          <td id="txtNRIC"></td>
                          <th scope="row">Payment Type</th>
                          <td id="txtPayType"></td>
                      </tr>
                      <tr>
                          <th scope="row">Advance Month</th>
                          <td id="txtAdvMth"></td>
                          <th scope="row"> Payment Date </th>
                          <td id="txtPayDate"></td>
                      </tr>
                      <tr>
                          <th scope="row">HP Code</th>
                          <td id="txtHPCode"></td>
                          <th scope="row">HP Name</th>
                          <td id="txtHPName"></td>
                      </tr>
                      <tr>
                          <th scope="row">Batch Payment ID</th>
                          <td id="txtBatchPaymentID"></td>
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
                          <th scope="row">Payment Collector Code</th>
                          <td id="txtCollectorCode"></td>
                          <th scope="row">HP Code/Dealer</th>
                          <td id="txtSalesPerson"></td>
                      </tr>
                       <tr>
                          <th scope="row">Branch Code</th>
                          <td id="txtBranch"></td>
                          <th scope="row">Debtor Account</th>
                          <td id="txtDebtor"></td>
                      </tr>
                  </tbody>
      </table>
      <ul class="center_btns">
          <li><p class="btn_blue2"><a href="javascript:showViewHistory_V()"><spring:message code='pay.btn.viewHistory'/></a></p></li>
      </ul>
      <section class="search_result"><!-- search_result start -->
        <article class="grid_wrap"  id="popList_wrap" style="width  : 100%;">
        </article><!-- grid_wrap end -->
      </section><!-- search_result end -->
      <section class="search_result"><!-- search_result start -->
         <aside class="title_line" ><!-- title_line start -->
          <h2 id="gridTitle">All Related Payments In This Transaction.(Click A Row To View Details) </h2>
          </aside><!-- title_line end -->
        <article class="grid_wrap"  id="popSlaveList_wrap" style="width  : 100%;">
        </article><!-- grid_wrap end -->
      </section><!-- search_result end -->
  </section><!-- pop_body end -->
</div><!-- popup_wrap end -->

<!-- content end -->
<form name="viewDetailForm" id="viewDetailForm"  method="post">
    <input type="hidden" name="payId" id="payId" value="${payId}" />
    <input type="hidden" name="salesOrdId" id="salesOrdId" value="${salesOrdId}" />
    <input type="hidden" name="callPrgm" id="callPrgm" value="${callPrgm}" />
</form>      
