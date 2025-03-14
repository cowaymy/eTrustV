<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>

<style type="text/css">

/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
}
.aui-grid-user-custom-right {
    text-align:right;
}

/* 커스컴 disable 스타일*/
.mycustom-disable-color {
    color : #cccccc;
}

/* 그리드 오버 시 행 선택자 만들기 */
.aui-grid-body-panel table tr:hover {
    background:#D9E5FF;
    color:#000;
}
.aui-grid-main-panel .aui-grid-body-panel table tr td:hover {
    background:#D9E5FF;
    color:#000;
}

</style>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>
<script type="text/javaScript" language="javascript">

//AUIGrid  ID
var mstGridID;

var optionModule = {
        type: "S",
        isShowChoose: false
};

var optionSystem = {
        type: "M",
        isShowChoose: false
};

var columnLayout = [
                    {dataField: "esnNo",headerText :"Ref No.",width: 180    ,height:30 , visible:true, editable : false},
                    {dataField: "posNo",headerText :"POS No.",width:220   ,height:30 , visible:true, editable : false},
                    {dataField: "posType",headerText :"POS Type" ,width:220   ,height:30 , visible:true, editable : false},
                    {dataField: "status",headerText :"Status" ,width:120   ,height:30 , visible:true, editable : false},
                    {dataField: "crtDt",headerText :"Sales Date",width:140   ,height:30 , visible:true ,editable : false},
                    {dataField: "crtBy",headerText :"Mmeber ID" ,width:140   ,height:30 , visible:true ,editable : false},
                    {dataField: "updDt",headerText :"Update Date",width:120   ,height:30 , visible:true,editable : false},
                    {dataField: "updBy",headerText :"Update By",width:120   ,height:30 , visible:true,editable : false},
                    {dataField: "courierSvc",headerText :"Courier Service",width:120   ,height:30 , visible:true ,editable : false},
                    {dataField: "waybillNo",headerText :"Waybill No",width:120   ,height:30 , visible:true,editable : false},
];

function createAUIGrid(){

	  var auiGridProps = {
		        usePaging           : true,         //페이징 사용
		        pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)
		        editable            : false,
		        fixedColumnCount    : 1,
		        showStateColumn     : false,
		        displayTreeOpen     : false,
		        headerHeight        : 30,
		        useGroupingPanel    : false,        //그룹핑 패널 사용
		        skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
		        wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
		        showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력
		        noDataMessage       : "No order found.",
		        groupingMessage     : "Here groupping"
		 };

        mstGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, "", auiGridProps);
        doGetCombo('/sales/posstock/selectEshopWhBrnchList.do' , '', '', 'branch', 'S', 'fn_selectedBranch');
}

function fn_selectedBranch(){
    if('${branchId}'){
        $("#branch").val("${branchId}".trim());
        $("#branch").attr("class", "w100p");
     }
    fn_selectEshopList();
}


function fn_selectPosEshopApprovalPop(){

    var selectedItems = AUIGrid.getSelectedItems(mstGridID);
    if(selectedItems.length <= 0) {
    	Common.alert("No order is selected.");
    	return;
    }
    else{
        if("${SESSION_INFO.userTypeId}"== "1" || "${SESSION_INFO.userTypeId}" == 2 || "${SESSION_INFO.userTypeId}" == 7){
            Common.alert("Only SO admin is allowed to approve e-Shop order");
        }
        else{
              if(selectedItems[0].item.status  !="Active"){
                    Common.alert('* Please check the status "ACT" status is only available.');
                    return ;
                }
                var esnNo = selectedItems[0].item.esnNo;
                Common.popupDiv("/sales/posstock/selectPosEshopApprovalList.do?esnNo="+esnNo, '' , null , true , "");
        }
    }
}

function fn_close(){
    location.reload();
}


function fn_updatePosInfo(){

    var selectedItems = AUIGrid.getSelectedItems(mstGridID);
    if(selectedItems.length <= 0) return;

    if(selectedItems[0].item.status  !="Processing"){
        Common.alert('* Please check the status "PROCESSING" status is only available.');
        return ;
    }

    var esnNo = selectedItems[0].item.esnNo;
    Common.popupDiv("/sales/posstock/updatePosInfo.do?esnNo="+esnNo, '' , null , true , "_insDiv");

}


$(document).ready(function(){

	createAUIGrid();

    //PosModuleTypeComboBox
    var moduleParam = {groupCode : 143, codeIn : [6795]};
    CommonCombo.make('posType', "/sales/pos/selectPosModuleCodeList", moduleParam , '', optionModule);


    //selectStatusCodeList
    var statusParam = {groupCode : 31};
    CommonCombo.make('status', "/sales/pos/selectStatusCodeList", statusParam , '', optionSystem);


    if("${SESSION_INFO.userTypeId}"== "1" || "${SESSION_INFO.userTypeId}" == 2 || "${SESSION_INFO.userTypeId}" == 7){

    	$("#updateInfo").hide();

        if("${SESSION_INFO.memberLevel}" =="1"){

            $("#orgCode").val("${orgCode}".trim());
            $("#orgCode").attr("class", "w100p readonly");
            $("#orgCode").attr("readonly", "readonly");

        }else if("${SESSION_INFO.memberLevel}" =="2"){

            $("#orgCode").val("${orgCode}".trim());
            $("#orgCode").attr("class", "w100p readonly");
            $("#orgCode").attr("readonly", "readonly");

            $("#grpCode").val("${grpCode}".trim());
            $("#grpCode").attr("class", "w100p readonly");
            $("#grpCode").attr("readonly", "readonly");

        }else if("${SESSION_INFO.memberLevel}" =="3"){

            $("#orgCode").val("${orgCode}".trim());
            $("#orgCode").attr("class", "w100p readonly");
            $("#orgCode").attr("readonly", "readonly");

            $("#grpCode").val("${grpCode}".trim());
            $("#grpCode").attr("class", "w100p readonly");
            $("#grpCode").attr("readonly", "readonly");

            $("#deptCode").val("${deptCode}".trim());
            $("#deptCode").attr("class", "w100p readonly");
            $("#deptCode").attr("readonly", "readonly");


        }else if("${SESSION_INFO.memberLevel}" =="4"){

            $("#orgCode").val("${orgCode}".trim());
            $("#orgCode").attr("class", "w100p readonly");
            $("#orgCode").attr("readonly", "readonly");

            $("#grpCode").val("${grpCode}".trim());
            $("#grpCode").attr("class", "w100p readonly");
            $("#grpCode").attr("readonly", "readonly");

            $("#deptCode").val("${deptCode}".trim());
            $("#deptCode").attr("class", "w100p readonly");
            $("#deptCode").attr("readonly", "readonly");
        }

        $("#memberId").val("${memCode}".trim());
        $("#memberId").attr("class", "w100p readonly");
        $("#memberId").attr("readonly", "readonly");
    }
    else{
    	$("#btnRejected").hide();
    }

    AUIGrid.bind(mstGridID, "cellDoubleClick", function(event) {
        var index = AUIGrid.getSelectedIndex(mstGridID)[0];

        if(index > -1) {
            var esnNo = AUIGrid.getCellValue(mstGridID, index, "esnNo");

            Common.popupDiv("/sales/posstock/eshopResultViewPop.do?esnNo="+esnNo, '' , null , true , '');
        }
        else{
            Common.alert('EShop Order Missing' + DEFAULT_DELIMITER + 'No Order Selected');
        }
    });

});



$(function(){

	 $('#btnAddItem').click(function() {
         Common.popupDiv("/sales/posstock/eshopItemRegisterPop.do");
     });

	  $('#btnEditItem').click(function() {
	      Common.popupDiv("/sales/posstock/eshopItemEditPop.do");
	  });

	  $('#btnShipping').click(function() {
          Common.popupDiv("/sales/posstock/eshopShippingPop.do");
      });

	  $('#btnOrder').click(function() {
          Common.popupDiv("/sales/posstock/eshopOrderPop.do");
      });

	  $('#btnApproval').click(function() {
		  fn_selectPosEshopApprovalPop();
      });

	  $('#btnRejected').click(function() {
		  fn_rejectedEshop();
      });

	  $('#btnUpdInfo').click(function() {
		  fn_updatePosInfo();
      });

	  $('#btnReceived').click(function() {
		  fn_completePos();
      });

	  $('#btnSearch').click(function() {
          fn_selectEshopList();
      });

	  $('#btnInvoiceGenerate').click(function() {
		  fn_generateInvoice();
      });

	  $('#btnReceiptGenerate').click(function() {
		  fn_posReceipt();
      });

	   $("#btnGenerateRawData").click(function() {
	         Common.popupDiv("/sales/posstock/posEshopRawDataPop.do", '', null, null, true);
	    });

       $("#btnStock").click(function() {
           Common.popupDiv("/sales/posstock/posEshopStockPop.do", '', null, null, true);
      });
});

function fn_rejectedEshop(){

	  var selectedItems = AUIGrid.getSelectedItems(mstGridID);
	  var selIdx = AUIGrid.getSelectedIndex(mstGridID)[0];

	    if(selectedItems.length <= 0) {
	        Common.alert("No order is selected.");
	        return;
	    }
	    else{
	        if(selectedItems[0].item.status  !="Active"){
		        Common.alert('* Please check the status "ACT" status is only available.');
		        return ;
	        }
	        else{
                fn_promptSelfCancellation(selIdx);
	        }
	     }
}

function fn_promptSelfCancellation(selIdx) {

	 var esnNo = AUIGrid.getCellValue(mstGridID, selIdx, "esnNo");
     var confirmCancelMsg =  "Are you sure to Cancel this order " + esnNo + "?";

      Common.confirm( confirmCancelMsg, function (){fn_selfCancellation(esnNo)});

}

function fn_selfCancellation(esnNo) {

	 var param = {
	           esnNo : esnNo,
	           eshopStatus : 6,
	           eshopRemark : " "
	       };

    Common.ajax("POST", "/sales/posstock/rejectPos.do", param , function(result) {
    	if(result.code == "00") {        //successful update
            Common.alert(" This ESN No: " +  esnNo + " has been cancelled.", fn_reloadList);
        } else {
            Common.alert(result.message,fn_reloadList);
         }
    });
}


function fn_reloadList() {
    location.reload();
}

function fn_selectEshopList(){

	Common.ajax("GET", "/sales/posstock/selectEshopList2", $("#searchForm").serialize(), function(result) {
	    AUIGrid.setGridData(mstGridID, result);
	});

}



function fn_completePos() {

    var selectedItems = AUIGrid.getSelectedItems(mstGridID);

	 if(selectedItems.length <= 0) {
		 Common.alert("No order is selected");
		 return ;
	 }

	 if(selectedItems[0].item.status  !="Delivery"){
	        Common.alert('* Please check the status "DELIVERY" status is only available.');
	        return ;
	 }

	 else{
	       var confirmSaveMsg = "Are you sure want to Complete?";
	       Common.confirm(confirmSaveMsg, updateStatus);
	 }
}


function updateStatus() {

	   var selectedItems = AUIGrid.getSelectedItems(mstGridID);
	   var esnNo = selectedItems[0].item.esnNo;
       var updateEshopData = {
           esnNo : esnNo,
           eshopStatus : 4
       };

       Common.ajax("POST", "/sales/posstock/completePos.do", updateEshopData, function(result) {
          if(result.code == "00") {        //successful update
              Common.alert(" This ESN No: " + esnNo + " has been completed.",fn_reloadList);
          } else {
                 Common.alert(result.message,fn_reloadList);
             }
       });
}

function fn_reloadList(){
    location.reload();
}

//크리스탈 레포트
function fn_generateInvoice(){
	  var selectedItems = AUIGrid.getSelectedItems(mstGridID);

	  if(selectedItems.length <= 0) {
		  Common.alert('<spring:message code="sal.alert.msg.noOrderSelected" />');
	  }
	  else{

        //report form에 parameter 세팅
        var taxInvcType = "142";             //taxInvoice Id
        var taxInvcSvcNo =selectedItems[0].item.posNo;       //service No


        $("#reportPDFForm #reportFileName").val('/statement/TaxInvoice_Miscellaneous_ItemBank_PDF_SST.rpt');

        reportDownFileName = 'TaxInvoice_' + taxInvcSvcNo;
        $("#reportPDFForm #reportDownFileName").val(reportDownFileName);

        $("#reportPDFForm #v_serviceNo").val(taxInvcSvcNo);
        $("#reportPDFForm #v_invoiceType").val(taxInvcType);

        //report 호출
        var option = {
                isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
        };

        Common.report("reportPDFForm", option);

    }
}


function fn_posReceipt(){

	  var selectedItems = AUIGrid.getSelectedItems(mstGridID);

      if(selectedItems.length <= 0) {
          Common.alert('<spring:message code="sal.alert.msg.noOrderSelected" />');
      }
      else{
    	  fn_report(selectedItems[0].item.posNo, "6795", "1353" );
      }
}


function fn_report(posNo, posModuleTypeId, posTypeId){

    //insert Log
    fn_insTransactionLog(posNo, posModuleTypeId ,  posTypeId);

    var option = {
            isProcedure : true
    };

    //params Setting
    $("#reportFileName").val("/sales/POSReceipt_New.rpt");
    $("#viewType").val("PDF");
    $("#V_POSREFNO").val(posNo);
    $("#V_POSMODULETYPEID").val(posModuleTypeId);
     $("#V_POSTYPEID").val(posTypeId);

    Common.report("reportPDFForm", option);
}


function fn_insTransactionLog(posNo, posTypeId){
    var transacMap = {};
    transacMap.rptChkPoint = "http://etrust.my.coway.com/sales/pos/selectPosList.do";
    transacMap.rptModule = "POS";
    transacMap.rptName = "POS Receipt";
    transacMap.rptSubName = "POS Receipt - PDF";
    transacMap.rptEtType = "pdf";
    transacMap.rptPath = getContextPath()+"/sales/POSReceipt_New.rpt";
    transacMap.rptParamtrValu = "@PosRefNo," + posNo  + ";@PosTypeId," + posTypeId;
    transacMap.rptRem = "";

    Common.ajax("GET", "/sales/pos/insertTransactionLog", transacMap, function(result){
        if(result == null){
            Common.alert('<spring:message code="sal.alert.msg.failToSaveLog" />');
        }
    });

}

$.fn.clearForm = function() {
    return this.each(function() {
        var type = this.type, tag = this.tagName.toLowerCase();
        if (tag === 'form'){
            return $(':input',this).clearForm();
        }
        if (type === 'text' || type === 'password'  || tag === 'textarea'){
            if($("#"+this.id).hasClass("readonly")){

            }else{
                this.value = '';
            }
        }else if (type === 'checkbox' || type === 'radio'){
            this.checked = false;

        }else if (tag === 'select'){
            if($("#memType").val() != "7"){ //check not HT level
                 this.selectedIndex = 0;
            }
        }
    });
};
</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Point of Sales</li>
    <li>Stock Movement</li>
    <li>e-Shop</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
    <h2>e-Shop</h2>
    <ul class="right_btns">

            <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
                    <li><p class="btn_blue"><a id="btnOrder" ><span class="add"></span>ORDER</a></p></li>
            </c:if>

            <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
                    <li><p class="btn_blue"><a id="btnReceived"><span class="edit"></span> RECEIVED</a></p></li>
            </c:if>

	        <c:if test="${PAGE_AUTH.funcUserDefine3 == 'Y'}">
	               <li><p class="btn_blue"><a id="btnApproval"><span class="edit"></span>APPROVAL</a></p></li>
	        </c:if>

	        <c:if test="${PAGE_AUTH.funcUserDefine4 == 'Y'}">
	               <li><p class="btn_blue"><a id="btnRejected"><span class="edit"></span>REJECT</a></p></li>
	        </c:if>

	        <c:if test="${PAGE_AUTH.funcUserDefine5 == 'Y'}">
	               <li><p class="btn_blue"><a id="btnSearch"><span class="search"   ></span>Search</a></p></li>
	        </c:if>

	        <c:if test="${PAGE_AUTH.funcUserDefine6 == 'Y'}">
	               <li><p class="btn_blue"><a id="btnClear" href="#" onclick="javascript:$('#searchForm').clearForm();"><span class="clear"></span><spring:message code='sales.Clear'/></a></p></li>
	        </c:if>
    </ul>
</aside><!-- title_line end -->
 <form name="reportPDFForm" id="reportPDFForm"  method="post">
    <input type="hidden" id="reportFileName" name="reportFileName" value="" />
    <input type="hidden" id="reportDownFileName" name="reportDownFileName" />
    <input type="hidden" id="viewType" name="viewType" value="PDF" />
    <input type="hidden" id="v_serviceNo" name="v_serviceNo" />
    <input type="hidden" id="v_invoiceType" name="v_invoiceType" />

     <!-- Receipt params -->
    <input type="hidden" id="V_POSREFNO" name="V_POSREFNO" />
    <input type="hidden" id="V_POSMODULETYPEID" name="V_POSMODULETYPEID" />
    <input type="hidden" id="V_POSTYPEID" name="V_POSTYPEID">
</form>

<form id="searchForm" name="searchForm" method="post" onsubmit="return false;">
<section class="search_table"><!-- search_table start -->
        <table summary="search table" class="type1"><!-- table start -->
            <caption>search table</caption>
            <colgroup>
                <col style="width:150px" />
                <col style="width:*" />
                <col style="width:160px" />
                <col style="width:*" />
                <col style="width:160px" />
                <col style="width:*" />
            </colgroup>
            <tbody>
             <tr>
                   <th scope="row">POS Type</th>
                   <td>
                         <select class="w100p" id="posType"  name="posType"></select>
                   </td>
                   <th scope="row">Reference No.</th>
                   <td>
                        <input  type="text" id="refNo" name="refNo"  ></input>
                   </td>
                   <th scope="row">Status</th>
                   <td>
<!--                         <select class="w100p" id="status" name="status"></select> -->
                        <select id="status" name="status" class="multy_select w100p" multiple="multiple">
                   </td>
             </tr>

             <tr>
                    <th scope="row">Sales Date</th>
                    <td >
                        <div class="date_set w100p"><!-- date_set start -->
                        <p><input id="fromSalesDt" name="fromSalesDt" type="text" title="Create start Date" value="${bfDay}" placeholder="DD/MM/YYYY" class="j_date"></p>
                        <span> To </span>
                        <p><input id="toSalesDt" name="toSalesDt" type="text" title="Create End Date" value="${toDay}" placeholder="DD/MM/YYYY" class="j_date"></p>
                        </div><!-- date_set end -->
                    </td>

                   <th scope="row">Member ID</th>
                   <td>
                        <input  type="text" id="memberId" name="memberId"  ></input>
                   </td>

                   <th scope="row">Branch</th>
                   <td>
                        <select  id="branch"  name="branch" class="w100p"></select>
                   </td>
            </tr>

             <tr>
                   <th scope="row">Org Code</th>
                   <td>
                        <input  type="text" id="orgCode" name="orgCode"  ></input>
                   </td>
                   <th scope="row">Grp Code</th>
                   <td>
                        <input  type="text" id="grpCode" name="grpCode"  ></input>
                   </td>
                   <th scope="row">Dept Code</th>
                   <td>
                        <input  type="text" id="deptCode" name="deptCode"  ></input>
                   </td>
              </tr>
            </tbody>
        </table><!-- table end -->
    </section><!-- search_table end -->


  </form>

<aside class="link_btns_wrap">
    <!-- link_btns_wrap start -->
    <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
    <dl class="link_list">
     <dt>Link</dt>
     <dd>
      <ul class="btns">
              <c:if test="${PAGE_AUTH.funcUserDefine7 == 'Y'}">
			        <li><p class="link_btn type2"><a id="btnAddItem" href="#">Add Item</a></p></li>
			        <li><p class="link_btn type2"><a id="btnEditItem" href="#">Edit Item</a></p></li>
			        <li><p class="link_btn type2"><a id="btnShipping" href="#">Shipping</a></p></li>
			        <li><p class="link_btn type2"><a id="btnInvoiceGenerate" href="#">Invoice</a></p></li>
			        <li><p class="link_btn type2"><a id="btnReceiptGenerate" href="#">Receipt</a></p></li>
			        <li><p class="link_btn type2"><a id="btnGenerateRawData">Raw Data</a></p></li>
			        <li><p class="link_btn type2"><a id="btnStock">Stock</a></p></li>
              </c:if>
      </ul>
      <p class="hide_btn">
        <a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a>
      </p>
     </dd>
    </dl>
</aside>

    <!-- data body start -->
    <section class="search_result"><!-- search_result start -->

        <ul class="right_btns" id="updateInfo">
            <li><p class="btn_grid"><a id="btnUpdInfo" >Update Info</a></p></li>
        </ul>

         <div id="grid_wrap" class="mt10" style="height:430px;"></div>
         <div id="grid_wrap_excel" class="mt10" style="height:430px;display:none;"></div>

         <ul class="center_btns mt20">
    </ul>

 </section><!-- search_result end -->


</section>