<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">

//AUIGrid 생성 후 반환 ID
var posGridID;
var posItmDetailGridID;

var optionModule = {
        type: "S",
        isShowChoose: false
};
var optionSystem = {
        type: "M",
        isShowChoose: false
};
var optionReasonChoose = {
        type: "M",
        isShowChoose: true
};
//Grid in SelectBox  - Selcet value
var arrPosStusCode; //POS GRID
var arrItmStusCode;  //ITEM GRID
var arrMemStusCode; //MEMBER GRID

//Ajax async
var ajaxOtp= {async : false};

$(document).ready(function() { //*************************************************************************

    createAUIGrid();
    createPosItmDetailGrid();
    girdHide();

     /*######################## Init Combo Box ########################*/

    //PosModuleTypeComboBox
    var moduleParam = {groupCode : 143, codeIn : [2390]};
    CommonCombo.make('cmbPosTypeId', "/sales/pos/selectPosModuleCodeList", moduleParam , '', optionModule);

    //PosSystemTypeComboBox
    var systemParam = {groupCode : 140 , codeIn : [5570, 5794]};

    CommonCombo.make('cmbSalesTypeId', "/sales/pos/selectPosModuleCodeList", systemParam , '', optionSystem);

    //selectStatusCodeList
    var statusParam = {groupCode : 30};
    CommonCombo.make('cmbStatusTypeId', "/sales/pos/selectStatusCodeList", statusParam , '', optionSystem);

    //branch List
    CommonCombo.make('cmbWhBrnchId', "/sales/pos/selectWhSOBrnchList", '' , '', '');


    //Wh List
    $("#cmbWhBrnchId").change(function() {

        var tempVal = $(this).val();
        if(tempVal == null || tempVal == '' ){
            $("#cmbWhId").val("");
        }else{
            var paramObj = {brnchId : tempVal};
            Common.ajax('GET', "/sales/pos/selectWarehouse", paramObj,function(result){

                if(result != null){
                    $("#cmbWhId").val(result.whLocDesc);
                }else{
                    $("#cmbWhId").val('');
                }
            });
        }
    });

    /*######################## Init Combo Box ########################*/

    //cmbPosTypeId Change Func
    $("#cmbPosTypeId").change(function() {

        var tempVal = $(this).val();


            var systemParam = {groupCode : 140 , codeIn : [5570]};
            var optionSystem = {
                    type: "M",
                    isShowChoose: false
            };
            CommonCombo.make('cmbSalesTypeId', "/sales/pos/selectPosModuleCodeList", systemParam , '', optionSystem);


    });

    //Member Search Popup
    $('#memBtn').click(function() {
        Common.popupDiv("/common/memberPop.do", $("#searchForm").serializeJSON(), null, true);
    });

    $('#salesmanCd').change(function(event) {

        var memCd = $('#salesmanCd').val().trim();

        if(FormUtil.isNotEmpty(memCd)) {
            fn_loadOrderSalesman(0, memCd);
        }
    });

    //Search
    $("#_search").click(function() {

        //Validation
        if(FormUtil.isEmpty($("#_posNo").val())){
        if(FormUtil.isEmpty($('#_sDate').val()) || FormUtil.isEmpty($('#_eDate').val())) {
                Common.alert('<spring:message code="sal.alert.msg.selectOrdDate" />');
                return;
        }
        }


        //Grid Clear
        AUIGrid.clearGridData(posGridID);
        AUIGrid.clearGridData(posItmDetailGridID);

        fn_getPosListAjax();
    });

    //Pos System
    $("#_systemBtn").click(function() {
        Common.popupDiv("/sales/pos/posFlexiSystemPop.do", '', null , true , '_insDiv');
    });

    // POS REVERSAL
    $("#_reversalBtn").click(function() {
      var clickChk = AUIGrid.getSelectedItems(posGridID);
      if(clickChk == null || clickChk.length <= 0 ){
        Common.alert('<spring:message code="sal.alert.msg.noOrderSelected" />');
        return;
      }

      if(clickChk[0].item.posTypeId == 1361 || clickChk[0].item.posTypeId == 5794){  // REVERSAL POS ARE PROHIBITED
        Common.alert('<spring:message code="sal.alert.msg.posProhibit" />');
        return;
      }

      // NO CHECKING FOR POS STATUS FOR REVERSAL -- TPY
      /*
      console.log("clickChk[0].item.stusId : " + clickChk[0].item.stusId);
      if(clickChk[0].item.stusId != 4){
        Common.alert('<spring:message code="sal.alert.msg.canNotbeReversalByCompl" />');
            return;
      }
      */

      // INVOICE CHECK
      var reRefNo = clickChk[0].item.posNo;
      var reObject = { reRefNo : reRefNo};
      var chkRv = true;

      Common.ajax("GET", "/sales/pos/chkReveralBeforeReversal", reObject, function(result) {
        if(result != null){
          chkRv = false;
        }
      }, null ,ajaxOtp);

      if(chkRv == false){
        Common.alert('<spring:message code="sal.alert.msg.posProhibit" />');
        return;
      }

      var isPay = false;
      var inPosNo = {};
      Common.ajax("GET", "/sales/pos/isPaymentKnowOffByPOSNo", inPosNo, function(result) {
            if(result == true){
              isPay = true;
            }
        }, null ,ajaxOtp);

      if(isPay == true){
        Common.alert('<spring:message code="sal.alert.msg.paymentKnockOff" />');
        return;
      }

      //Call controller
      var reversalForm = { posId : clickChk[0].item.posId, ind : "2" };
      Common.popupDiv("/sales/pos/posReversalPop.do", reversalForm , null , true , "_revDiv");
    });

    $("#_convertBtn").click(function() {

        var clickChk = AUIGrid.getSelectedItems(posGridID);
        //Validation
        if(clickChk == null || clickChk.length <= 0 ){
            Common.alert('<spring:message code="sal.alert.msg.noOrderSelected" />');
            return;
        }

        var stusId = clickChk[0].item.stusId;
        if(stusId != 107 ){
        	  Common.alert("Invalid status for POS Convert.");
              return;
        }


        var convertForm = { posId : clickChk[0].item.posId };
        Common.popupDiv("/sales/pos/posFlexiConfirmPop.do", convertForm , null , true , "_revDiv");

    });


    $("#_addItemBtn").click(function() {
        Common.popupDiv("/sales/pos/posFlexiAddItemPop.do", '' , null , true , "_insDiv");
    });


    // 셀 더블클릭 이벤트 바인딩
    /* AUIGrid.bind(posGridID, "cellDoubleClick", function(event){
        alert("개발중...");
    }); */
    //Cell Click Event
    AUIGrid.bind(posGridID, "cellClick", function(event){

        //clear data
        AUIGrid.clearGridData(posItmDetailGridID);

        if(event.item.posModuleTypeId == 2390 || event.item.posModuleTypeId == 2392){ // POS SALES & OTHER(ITEM BANK(HQ))

            //Mybatis Separate Param
            //1. Grid Display Control
            $("#_itmDetailflexGridDiv").css("display" , "");
            $("#_paymentDetailGridDiv").css("display" , "");
            $("#_deducFlexGridDiv").css("display", "none");

            var detailParam = {rePosId : event.item.posId};
            var posParam = { billNo : event.item.posNo };
            //Ajax
            Common.ajax("GET", "/sales/pos/getPosDetailList", detailParam, function(result){
                AUIGrid.setGridData(posItmDetailGridID, result);
                AUIGrid.resize(posItmDetailGridID);
            });

        }
    });


    /***************  Pos Grid Status ********************/
     //1) Master
     AUIGrid.bind(posGridID, "cellEditBegin", function(event) {
            //Reversal
             if(event.item.posTypeId == 1361){
                 Common.alert('<spring:message code="sal.alert.msg.canNotChngStatus" />');
                 return false;
             }
            // Active NonReceive Only
             if(event.value != 1 && event.value != 96){
                Common.alert('<spring:message code="sal.alert.msg.canNotChngStatus" />');
                return false;
            }

            //Others
            return true;
    });
    // 2) Detail
     AUIGrid.bind(posItmDetailGridID, "cellEditBegin", function(event) {

         if(event.item.posTypeId == 1361){
             Common.alert('<spring:message code="sal.alert.msg.canNotChngStatusByReversal" />');
             return false;
         }
         // Active NonReceive Only
          if(event.value != 96){
             Common.alert('<spring:message code="sal.alert.msg.canNotChngStatus" />');
             return false;
         }
         //Others
         return true;
     });


     /***  Report ***/
     $("#_posFlexiRawDataBtn").click(function() {
         Common.popupDiv("/sales/pos/posFlexiRawDataPop.do", '', null, null, true);
    });

});//Doc ready Func End ****************************************************************************************************************************************


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



function girdHide(){
    //Grid Hide
    $("#_deducFlexGridDiv").css("display" , "none");
    $("#_itmDetailflexGridDiv").css("display" , "none");
}

function createPosItmDetailGrid(){
    var posItmColumnLayout =  [
                                {dataField : "stkCode", headerText : '<spring:message code="sal.title.itemCode" />', width : '10%' , editable : false},
                                {dataField : "stkDesc", headerText : '<spring:message code="sal.title.itemDesc" />', width : '30%' , editable : false},
                                {dataField : "qty", headerText : '<spring:message code="sal.title.qty" />', width : '10%' , editable : false},
                                {dataField : "amt", headerText : '<spring:message code="sal.title.unitPrice" />', width : '10%' , dataType : "numeric", formatString : "#,##0.00" , editable : false},
                                {dataField : "chrg", headerText : '<spring:message code="sal.title.subTotalExclGST" />', width : '10%', dataType : "numeric", formatString : "#,##0.00" , editable : false},
                                {dataField : "txs", headerText : '<spring:message code="sal.title.gstSixPerc" />', width : '10%', dataType : "numeric", formatString : "#,##0.00" , editable : false},
                                {dataField : "tot", headerText : '<spring:message code="sal.text.totAmt" />', width : '10%', dataType : "numeric", formatString : "#,##0.00" , editable : false},
                                { dataField : "stusDesc",  headerText : "Status", width : '10%', editable : false
                                  /*  labelFunction : function( rowIndex, columnIndex, value, headerText, item) {
                                        var retStr = "";
                                        for(var i=0,len=arrItmStusCode.length; i<len; i++) {
                                            if(arrItmStusCode[i]["codeId"] == value) {
                                                retStr = arrItmStusCode[i]["codeName"];
                                                break;
                                            }
                                        }
                                        return retStr == "" ? value : retStr;
                                    },
                                    editRenderer : { // 셀 자체에 드랍다운리스트 출력하고자 할 때
                                           type : "DropDownListRenderer",
                                           list : arrItmStusCode,
                                           keyField   : "codeId", // key 에 해당되는 필드명
                                           valueField : "codeName", // value 에 해당되는 필드명
                                           easyMode : false
                                     } */
                               },
                               {dataField : "posId", visible : false},
                               {dataField : "posTypeId", visible : false},
                               {dataField : "posModuleTypeId", visible : false},
                               {dataField : "posItmId", visible : false}
                           ];
     //그리드 속성 설정
    var itmGridPros = {

            usePaging           : true,         //페이징 사용
            pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)
            fixedColumnCount    : 1,
            showStateColumn     : true,
            displayTreeOpen     : false,
  //          selectionMode       : "singleRow",  //"multipleCells",
            headerHeight        : 30,
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : true
    };

    posItmDetailGridID = GridCommon.createAUIGrid("#itm_detail_grid_wrap_flex", posItmColumnLayout,'', itmGridPros);  // address list
}


//TODO 미개발 message
function fn_underDevelop(){
    Common.alert('The program is under development.');
}

$.fn.clearForm = function() {
    return this.each(function() {
        var type = this.type, tag = this.tagName.toLowerCase();
        if (tag === 'form'){
            return $(':input',this).clearForm();
        }
        if (type === 'text' || type === 'password' || type === 'hidden' || tag === 'textarea'){
            this.value = '';
        }else if (type === 'checkbox' || type === 'radio'){
            this.checked = false;
        }else if (tag === 'select'){
            this.selectedIndex = -1;
        }
    });
};


function fn_loadOrderSalesman(memId, memCode, isPop) {

    Common.ajax("GET", "/sales/order/selectMemberByMemberIDCode.do", {memId : memId, memCode : memCode}, function(memInfo) {

        if(memInfo == null) {
            Common.alert('<spring:message code="sal.alert.msg.memNotFound" />'+memCode+'</b>');
            $("#salesmanPopCd").val('');
            $("#hiddenSalesmanPopId").val('');
            //Clear Grid
            fn_clearAllGrid();
        }
        else {
           // console.log("멤버정보 가꼬옴");
            if(isPop == 1){
            //  console.log("팝임");
            //  console.log("memInfo.memId : " + memInfo.memId);
                $('#hiddenSalesmanPopId').val(memInfo.memId);
                $('#salesmanPopCd').val(memInfo.memCode);
                $('#salesmanPopCd').removeClass("readonly");
                $('#salesmanPopNm').val(memInfo.name);

                 Common.ajax("GET", "/sales/pos/getMemCode", {memCode : memCode},function(result){

                    if(result != null){
                        //$("#_cmbWhBrnchIdPop").val(result.brnch);
                        //$("#_payBrnchCode").val(result.brnch);
                        //getLocIdByBrnchId(result.brnch);
                    }else{
                        Common.alert('<spring:message code="sal.alert.msg.memHasNoBrnch" />');
                        $("#salesmanPopCd").val('');
                        $("#hiddenSalesmanPopId").val('');
                        $("#_cmbWhBrnchIdPop").val('');
                        $("#cmbWhIdPop").val();
                        //Clear Grid
                        fn_clearAllGrid();
                        return;
                    }
                 });
            }else{
             // console.log("리스트임");
                $('#hiddenSalesmanId').val(memInfo.memId);
                $('#salesmanCd').val(memInfo.memCode);
                $('#salesmanCd').removeClass("readonly");
                $('#salesmanPopNm').val(memInfo.name);
            }
        }
    });
}


function createAUIGrid(){


    var posColumnLayout =  [
                            {dataField : "posNo", headerText : '<spring:message code="sal.title.posNo" />', width : '8%' , editable : false},
                            {dataField : "posDt", headerText : '<spring:message code="sal.title.salDate" />', width : '8%', editable : false},
                            {dataField : "userName", headerText : '<spring:message code="sal.title.memberId" />', width : '8%' , editable : false},
                            {dataField : "codeName", headerText : '<spring:message code="sal.title.posType" />', width : '8%' , editable : false},
                            {dataField : "codeName1", headerText : '<spring:message code="sal.title.salesType" />', width : '8%' , editable : false},
/*                             {dataField : "taxInvcRefNo", headerText : '<spring:message code="sal.title.invoiceNo" />', width : '7%' , editable : false},
                            {dataField : "memoAdjRefNo", headerText : "Adjust. Note", width : '8%' , editable : false}, */
                            {dataField : "name", headerText : '<spring:message code="sal.text.custName" />', width : '15%' , editable : false},
                            {dataField : "brnchDesc", headerText : '<spring:message code="sal.text.branch" />', width : '8%' , style : 'left_style' , editable : false},
                            {dataField : "whLocDesc", headerText : '<spring:message code="sal.title.warehouse" />', width : '8%' , editable : false},
                            {dataField : "posTotAmt", headerText : '<spring:message code="sal.text.totAmt" />', width : '8%' , editable : false},
                            {dataField : "stusDesc", headerText : "Status", width : '8%', editable : false} ,
                            {dataField : "apvUserName", headerText : "Approve By", width : '8%', editable : false},
                            {dataField : "apvDt", headerText : "Approve Date", width : '8%', editable : false},
                            {dataField : "posId", visible : false},
                            {dataField : "posModuleTypeId", visible : false},
                            {dataField : "posTypeId", visible : false},
                            {dataField : "stusId", visible : false}
                           ];

    //그리드 속성 설정
    var gridPros = {

            usePaging           : true,         //페이징 사용
            pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)
            fixedColumnCount    : 1,
            showStateColumn     : true,
            displayTreeOpen     : false,
       //     selectionMode       : "singleRow",  //"multipleCells",
            headerHeight        : 30,
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : true
    };

    posGridID = GridCommon.createAUIGrid("#pos_grid_wrap", posColumnLayout,'', gridPros);  // address list
}

function fn_getPosListAjax(){

      Common.ajax("GET", "/sales/pos/selectPosFlexiJsonList", $("#searchForm").serialize(), function(result) {

          AUIGrid.setGridData(posGridID, result);
      });

}

/*************   Report *************/

function fn_posReceipt(){

    var clickChk = AUIGrid.getSelectedItems(posGridID);
    //Validation
    if(clickChk == null || clickChk.length <= 0 ){
        Common.alert('<spring:message code="sal.alert.msg.noOrderSelected" />');
        return;
    }

    console.log("clickChk[0].item.posModuleTypeId : " + clickChk[0].item.posModuleTypeId);
    console.log("clickChk[0].item.posTypeId : " + clickChk[0].item.posTypeId);



    fn_report(clickChk[0].item.posNo, clickChk[0].item.posModuleTypeId , clickChk[0].item.posTypeId );

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

    Common.report("rptForm", option);
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

    console.log("transacMap " + transacMap);

    Common.ajax("GET", "/sales/pos/insertTransactionLog", transacMap, function(result){
        if(result == null){
            Common.alert('<spring:message code="sal.alert.msg.failToSaveLog" />');
        }
        /* else{
            console.log("insert log : " + result.message);
        } */
    });

}




//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

</script>

<form id="rptForm">
    <input type="hidden" id="reportFileName" name="reportFileName" /><!-- Report Name  -->
    <input type="hidden" id="viewType" name="viewType"  /><!-- View Type  -->
    <!-- <input type="hidden" id="reportDownFileName" name="reportDownFileName" value="123123" /> --><!-- Download Name -->

    <!-- Receipt params -->
    <input type="hidden" id="V_POSREFNO" name="V_POSREFNO" />
    <input type="hidden" id="V_POSMODULETYPEID" name="V_POSMODULETYPEID" />
    <input type="hidden" id="V_POSTYPEID" name="V_POSTYPEID">

    <!--Raw Data  -->
    <input type="hidden" id="V_WHERESQL" name="V_WHERESQL"/>

    <!--Payment Listing  -->
    <input type="hidden" id="V_SHOWPAYMENTDATE" name="V_SHOWPAYMENTDATE">
    <input type="hidden" id="V_SHOWKEYINBRANCH" name="V_SHOWKEYINBRANCH">
    <input type="hidden" id="V_SHOWRECEIPTNO" name="V_SHOWRECEIPTNO">
    <input type="hidden" id="V_SHOWTRNO" name="V_SHOWTRNO">
    <input type="hidden" id="V_SHOWKEYINUSER" name="V_SHOWKEYINUSER">
    <input type="hidden" id="V_SHOWPOSNO" name="V_SHOWPOSNO">
    <input type="hidden" id="V_SHOWMEMBERCODE" name="V_SHOWMEMBERCODE">
    <input type="hidden" id="V_SHOWPOSTYPEID" name="V_SHOWPOSTYPEID">
</form>
<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Point Of Sales</li>
    <li>POS - Flexi Point</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>POS - Flexi Point</h2>
<ul class="right_btns">
  <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
    <li><p class="btn_blue"><a href="#" id="_systemBtn"><spring:message code="sal.title.text.posSystem" /></a></p></li>
  </c:if>
  <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
    <li><p class="btn_blue"><a href="#" id="_reversalBtn"><spring:message code="sal.title.text.posReversal" /></a></p></li>
  </c:if>
  <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
    <li><p class="btn_blue"><a href="#" id="_convertBtn">Convert POS</a></p></li>
  </c:if>
  <c:if test="${PAGE_AUTH.funcUserDefine4 == 'Y'}">
     <li><p class="btn_blue"><a href="#" id="_addItemBtn">Add POS Flexi Item</a></p></li>
  </c:if>
  <c:if test="${PAGE_AUTH.funcView == 'Y'}">
    <li><p class="btn_blue"><a href="#" id="_search"><span class="search"></span><spring:message code="sal.btn.search" /></a></p></li>
  </c:if>
  <li><p class="btn_blue"><a href="#" onclick="javascript:$('#searchForm').clearForm();"><span class="clear"></span><spring:message code="sal.btn.clear" /></a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form  id="searchForm">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.title.posType" /></th>
    <td>
    <select class="w100p" id="cmbPosTypeId"  name="posModuleTypeId"></select>
    </td>
    <th scope="row"><spring:message code="sal.title.text.posSalesType" /></th>
    <td>
    <select class="w100p" id="cmbSalesTypeId" name="posTypeId" ></select>
    </td>
    <th scope="row"><spring:message code="sal.title.status" /></th>
    <td>
        <select class="w100p" id="cmbStatusTypeId" name="posStatusId" ></select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.posRefNo" /></th>
    <td>
    <input type="text" title="" placeholder="POS No." class="w100p"  id="_posNo" name="posNo" />
    </td>
    <th scope="row"><spring:message code="sal.title.salDate" /></th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date"  name="sDate" id="_sDate" value="${bfDay}"/></p>
    <span><spring:message code="sal.title.to" /></span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" name="eDate"  id="_eDate" value="${toDay}"/></p>
    </div><!-- date_set end -->
    </td>
    <th scope="row"><spring:message code="sal.text.memberCode" /></th>
    <td>
        <div class="search_100p"><!-- search_100p start -->
        <input id="salesmanCd" name="salesmanCd" type="text" title="" placeholder="" class="w100p" />
        <input id="hiddenSalesmanId" name="salesmanId" type="hidden"  />
        <a id="memBtn" href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
        </div>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.brnchWarehouse" /></th>
    <td><select  id="cmbWhBrnchId"  name="brnchId" class="w100p"></select></td>
    <td colspan="2" style="padding-left:0"><input type="text" disabled="disabled" id="cmbWhId" class="w100p"></td>
    <th scope="row"><spring:message code="sal.text.custName" /></th>
    <td>
    <input type="text" title="" placeholder="Customer Name" class="w100p" name="posCustName" />
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.memNameDeduc" /></th>
    <td>
        <input type="text" title="" placeholder="Member Name" class="w100p" name="deducMem" id="_deducMem" />
    </td>
    <th scope="row"><spring:message code="sal.title.text.memIcDeduc" /></th>
    <td colspan="3">
    <input type="text" title="" placeholder="Member IC" class="w100p"  name="deducMemNric" id="_deducMemNric"/>
    </td>
</tr>
</tbody>
</table><!-- table end -->

 <aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
    <dt><spring:message code="sal.title.text.link" /></dt>
    <dd>
    <ul class="btns">
  <%--       <c:if test="${PAGE_AUTH.funcUserDefine3 == 'Y'}"> --%>
        <li><p class="link_btn"><a href="#" onclick="javascript : fn_posReceipt()"><spring:message code="sal.title.text.posReceipt" /></a></p></li>
                <li><p class="link_btn type2"><a id="_posFlexiRawDataBtn">Pos Flexi Raw Data</a></p></li>
<%--         </c:if> --%>
    </ul>
  <%--   <ul class="btns">
        <c:if test="${PAGE_AUTH.funcUserDefine3 == 'Y'}">
        <li><p class="link_btn type2"><a id="_posPayListing"><spring:message code="sal.title.text.posPaymentListing" /></a></p></li>
        </c:if>
        <c:if test="${PAGE_AUTH.funcUserDefine3 == 'Y'}">
        <li><p class="link_btn type2"><a id="_posRawDataBtn"><spring:message code="sal.title.text.posRawData" /></a></p></li>
        </c:if>
    </ul> --%>
    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside><!-- link_btns_wrap end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<aside class="title_line"><!-- title_line start -->
<h3><spring:message code="sal.title.text.resultList" /></h3>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="pos_grid_wrap" style="width:100%; height:300px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<ul class="center_btns">
    <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
    </c:if>
 <%--    <li><p class="btn_blue2 big"><a id="_headerSaveBtn"><spring:message code="sal.btn.save" /></a></p></li> --%>
</ul>
<!-- deduction Grid -->
<div id="_deducFlexGridDiv">
<aside class="title_line"><!-- title_line start -->
<h3><spring:message code="sal.title.text.deducMemList" /></h3>
</aside><!-- title_line end -->
<article class="grid_wrap"><!-- grid_wrap start -->
<div id="deduc_grid_wrap" style="width:100%; height:300px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->
<ul class="center_btns">
    <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
    </c:if>
    <%-- <li><p class="btn_blue2 big"><a id="_deducSaveBtn"><spring:message code="sal.btn.save" /></a></p></li> --%>
</ul>
</div>
<!--item Grid  -->
<div id="_itmDetailflexGridDiv">
<aside class="title_line"><!-- title_line start -->
<h3><spring:message code="sal.title.itmList" /></h3>
</aside><!-- title_line end -->
<article class="grid_wrap"><!-- grid_wrap start -->
<div id="itm_detail_grid_wrap_flex" style="width:100%; height:300px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<ul class="center_btns">
    <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
    </c:if>
   <%--  <li><p class="btn_blue2 big"><a id="_itemSaveBtn"><spring:message code="sal.btn.save" /></a></p></li> --%>
</ul>
</div>

</section><!-- search_result end -->
</section><!-- content end -->
<hr />
