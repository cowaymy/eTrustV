<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">

//Combo Box Choose Message
var optionState = {chooseMessage: " 1.States "};
var optionCity = {chooseMessage: "2. City"};
var optionPostCode = {chooseMessage: "3. Post Code"};
var optionArea = {chooseMessage: "4. Area"};

//생성 후 반환 ID
var purchaseGridID;
var optionModule = {
        type: "S",
        isShowChoose: false
};
//posCustId
$(document).ready(function() {
	//MagicAddr
    fn_initAddress();
    CommonCombo.make('mState', "/sales/customer/selectMagicAddressComboList", '' , '', optionState);

    //MagicAddr
    createPurchaseGridID();
    //PosModuleTypeComboBox
    var modulePopParam = {groupCode : 143, codeIn : [2392]};
    CommonCombo.make('_insPosModuleType', "/sales/pos/selectPosModuleCodeList", modulePopParam , '', optionModule);

    //PosSystemTypeComboBox
    var systemPopParam = {groupCode : 140 , codeIn : [1357, 1358]};
    CommonCombo.make('_insPosSystemType', "/sales/pos/selectPosModuleCodeList", systemPopParam , '', optionModule);

    CommonCombo.make('_cmbWhBrnchIdPop', "/sales/pos/selectWhBrnchList", '' , '', '');

    //Wh List
    $("#_cmbWhBrnchIdPop").change(function() {
        getLocIdByBrnchId($(this).val());
    });

    $("#_purcDelBtn").click(function() {

    	AUIGrid.removeCheckedRows(purchaseGridID);
    });

    //Purchase Btn
    $("#_purchBtn").click(function() {

    	 if($("#hiddenSalesmanPopId").val() == null || $("#hiddenSalesmanPopId").val() ==	 ''){
    		 Common.alert('<spring:message code="sal.alert.msg.plzKeyinMember" />');
    		 return;
    	 }
    	 //TODO 창고 파라미터가져가야함
    	 Common.popupDiv("/sales/pos/posItmSrchPop.do", $("#_sysForm").serializeJSON(), null, true);
    });

  //Save Request
    $("#_posReqSaveBtn").click(function() {

    	//remark
    	if($("#_insPosSystemType").val() == 1357){ //income
    		//_posRemark
    		$("#_posRemark").val($("#_posRemarkOth").val());
    	}
        if($("#_insPosSystemType").val() == 1358){//hq
            //_posRemark
            $("#_posRemark").val($("#_posRemarkHq").val());
        }

        /****Validation ***/
        //Purchase Grid Null Check
        if(AUIGrid.getGridData(purchaseGridID) <= 0){
            Common.alert("* Please select the Item(s). ");
            return;
        }

        //Member Check
        var ajaxOption = {
            async: false,
            isShowLoader : true
        };
        Common.ajax("GET", "/sales/order/selectMemberByMemberIDCode.do", {memId : $("#hiddenSalesmanPopId").val(), memCode : $("#salesmanPopCd").val()}, function(memInfo) {
            if(memInfo == null) {
                Common.alert('<spring:message code="sal.alert.msg.memNotFound" />'+memCode+'</b>');
                return;
            }
        },null,ajaxOption);

        //Branch WareHouse Null Check
/*         if( null == $("#_cmbWhBrnchIdPop").val() || '' == $("#_cmbWhBrnchIdPop").val()){
            Common.alert("* Please select the warehouse. ");
            return;
        } */
/*         //Receive Date Null Check
        if( null == $("#_recvDate").val() || '' == $("#_recvDate").val()){
            Common.alert("* Please select the Receive date.");
            return;
        } */
        // Compare with Todaty?

        //Remark Null Check
        if( null == $("#_posRemark").val() || '' == $("#_posRemark").val()){
            Common.alert('<spring:message code="sal.alert.msg.plzKeyinRemark" />');
            return;
        }
        //Save
       fn_payPass(); //No payment Save

    });

    //Enter Event
    $('#searchSt').keydown(function (event) {
        if (event.which === 13) {    //enter
            fn_addrSearch();
        }
    });

    //Pos Sales Type Change
    $("#_insPosSystemType").change(function() {

		if(this.value == 1357){  //INCOMOE
			$("#_divOth").css("display" , "");
			$("#_divHq").css("display" , "none");

			//FIELD CLEAR
			fn_initAddress();
			$("#_insPosCustName").val("");
			$("#searchSt").val("");
			$("#addrDtl").val("");
			$("#streetDtl").val("");
			$("#_posRemark").val("");
			$("#_posRemarkOth").val("");

			//CLEAR GRID
			AUIGrid.clearGridData(purchaseGridID);
		}

	    if(this.value == 1358){  //HQ
	    	$("#_divOth").css("display" , "none");
            $("#_divHq").css("display" , "");
           //FIELD CLEAR
           $("#salesmanPopCd").val("");
           $("#_cmbWhBrnchIdPop").val("");
           $("#cmbWhIdPop").val("");
           $("#_recvDate").val("");
           $("#_posRemark").val("");
           $("#_posRemarkHq").val("");
          //CLEAR GRID
            AUIGrid.clearGridData(purchaseGridID);
        }

	});

  //Member Search Popup
    $('#memBtnPop').click(function() {
        var callParam = {callPrgm : "1"};
        Common.popupDiv("/common/memberPop.do", callParam, null, true);
    });

    $('#salesmanPopCd').change(function(event) {

        var memCd = $('#salesmanPopCd').val().trim();

        if(FormUtil.isNotEmpty(memCd)) {
            fn_loadOrderSalesman(0, memCd, 1);
        }
    });
});//Document Ready Func End


//////////////////////////////////////////////////
function getLocIdByBrnchId(tempVal) {

	   /*  var tempVal = $(this).val(); */
	    if(tempVal == null || tempVal == '' ){
	        $("#cmbWhIdPop").val("");
	    }else{
	        var paramObj = {brnchId : tempVal};
	        Common.ajax('GET', "/sales/pos/selectWarehouse", paramObj,function(result){

	            if(result != null){
	                $("#cmbWhIdPop").val(result.whLocDesc);
	                $("#_hidLocId").val(result.whLocId);
	            }else{
	                $("#cmbWhIdPop").val('');
	                $("#_hidLocId").val('');
	            }
	        });
	    }
	}
//////////////////////////////////////////////////
function fn_payPass(){

    var data = {};
    var prchParam = AUIGrid.getGridData(purchaseGridID);

    data.prch = prchParam;
    $("#_payResult").val('-1'); //payment
    data.form = $("#_sysForm").serializeJSON();

    Common.ajax("POST", "/sales/pos/insertPos.do", data,function(result){
        Common.alert('<spring:message code="sal.alert.msg.posSavedShowRefNo"  arguments="'+result.reqDocNo+'"/>' ,  fn_bookingAndpopClose());
        //Common.alert("POS saved. <br /> POS Ref No. :  [" + result.reqDocNo + "]" ,  fn_bookingAndpopClose());

    });

}

/* function fn_bookingAndpopClose(){
   //프로시저 호출
   // 콜백  >>
   $("#_systemClose").click();
} */
//////////////////////////////////////////////////


function fn_initAddress(){

    $('#mCity').append($('<option>', { value: '', text: '2. City' }));
    $('#mCity').val('');
    $("#mCity").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});

    $('#mPostCd').append($('<option>', { value: '', text: '3. Post Code' }));
    $('#mPostCd').val('');
    $("#mPostCd").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});

    $('#mArea').append($('<option>', { value: '', text: '4. Area' }));
    $('#mArea').val('');
    $("#mArea").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});
}

function fn_selectState(selVal){

    var tempVal = selVal;

    if('' == selVal || null == selVal){
        //전체 초기화
        fn_initAddress();

    }else{

        $("#mCity").attr({"disabled" : false  , "class" : "w100p"});

        $('#mPostCd').append($('<option>', { value: '', text: '3. Post Code' }));
        $('#mPostCd').val('');
        $("#mPostCd").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});

        $('#mArea').append($('<option>', { value: '', text: '4. Area' }));
        $('#mArea').val('');
        $("#mArea").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});

        //Call ajax
        var cityJson = {state : tempVal}; //Condition
        CommonCombo.make('mCity', "/sales/customer/selectMagicAddressComboList", cityJson, '' , optionCity);
    }

}


function fn_selectCity(selVal){

    var tempVal = selVal;

    if('' == selVal || null == selVal){

         $('#mPostCd').append($('<option>', { value: '', text: '3. Post Code' }));
         $('#mPostCd').val('');
         $("#mPostCd").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});

         $('#mArea').append($('<option>', { value: '', text: '4. Area' }));
         $('#mArea').val('');
         $("#mArea").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});

    }else{

         $("#mPostCd").attr({"disabled" : false  , "class" : "w100p"});

         $('#mArea').append($('<option>', { value: '', text: '4. Area' }));
         $('#mArea').val('');
         $("#mArea").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});


        //Call ajax
        var postCodeJson = {state : $("#mState").val() , city : tempVal}; //Condition
        CommonCombo.make('mPostCd', "/sales/customer/selectMagicAddressComboList", postCodeJson, '' , optionPostCode);
    }

}


function fn_selectPostCode(selVal){

    var tempVal = selVal;

    if('' == selVal || null == selVal){

        $('#mArea').append($('<option>', { value: '', text: '4. Area' }));
        $('#mArea').val('');
        $("#mArea").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});

    }else{

        $("#mArea").attr({"disabled" : false  , "class" : "w100p"});

        //Call ajax
        var areaJson = {state : $("#mState").val(), city : $("#mCity").val() , postcode : tempVal}; //Condition
        CommonCombo.make('mArea', "/sales/customer/selectMagicAddressComboList", areaJson, '' , optionArea);
    }

}


function fn_addrSearch(){
    if($("#searchSt").val() == ''){
        Common.alert("Please search.");
        return false;
    }
    var srchParam = {searchSt : $("#searchSt").val()};
    Common.popupDiv('/sales/customer/searchMagicAddressPop.do' , srchParam , null , true, '_searchDiv');
}


function fn_addMaddr(marea, mcity, mpostcode, mstate, areaid, miso){

    if(marea != "" && mpostcode != "" && mcity != "" && mstate != "" && areaid != "" && miso != ""){

        $("#mArea").attr({"disabled" : false  , "class" : "w100p"});
        $("#mCity").attr({"disabled" : false  , "class" : "w100p"});
        $("#mPostCd").attr({"disabled" : false  , "class" : "w100p"});
        $("#mState").attr({"disabled" : false  , "class" : "w100p"});

        //Call Ajax

        CommonCombo.make('mState', "/sales/customer/selectMagicAddressComboList", '' , mstate, optionState);

        var cityJson = {state : mstate}; //Condition
        CommonCombo.make('mCity', "/sales/customer/selectMagicAddressComboList", cityJson, mcity , optionCity);

        var postCodeJson = {state : mstate , city : mcity}; //Condition
        CommonCombo.make('mPostCd', "/sales/customer/selectMagicAddressComboList", postCodeJson, mpostcode , optionCity);

        var areaJson = {groupCode : mpostcode};
        var areaJson = {state : mstate , city : mcity , postcode : mpostcode}; //Condition
        CommonCombo.make('mArea', "/sales/customer/selectMagicAddressComboList", areaJson, marea , optionArea);

        $("#areaId").val(areaid);
        $("#_searchDiv").remove();
    }else{
        Common.alert('<spring:message code="sal.alert.msg.addrCheck" />');
    }
}

//Get Area Id
function fn_getAreaId(){

    var statValue = $("#mState").val();
    var cityValue = $("#mCity").val();
    var postCodeValue = $("#mPostCd").val();
    var areaValue = $("#mArea").val();



    if('' != statValue && '' != cityValue && '' != postCodeValue && '' != areaValue){

        var jsonObj = { statValue : statValue ,
                              cityValue : cityValue,
                              postCodeValue : postCodeValue,
                              areaValue : areaValue
                            };
        Common.ajax("GET", "/sales/customer/getAreaId.do", jsonObj, function(result) {

             $("#areaId").val(result.areaId);

        });

    }

}

////////////// Magic Addr End //////////////


function createPurchaseGridID(){


    var posColumnLayout =  [
                            {dataField : "stkCode", headerText : '<spring:message code="sal.title.itemCode" />', width : '10%'},
                            {dataField : "stkDesc", headerText : '<spring:message code="sal.title.itemDesc" />', width : '30%'},
                            {dataField : "qty", headerText : '<spring:message code="sal.title.text.invStock" />', width : '10%'},
                            {dataField : "inputQty", headerText : '<spring:message code="sal.title.qty" />', width : '10%'},
                            {dataField : "amt", headerText : '<spring:message code="sal.title.unitPrice" />', width : '10%' , dataType : "numeric", formatString : "#,##0.00"},
                            {dataField : "subTotal", headerText : '<spring:message code="sal.title.subTotalExclGST" />', width : '10%', dataType : "numeric", formatString : "#,##0.00", expFunction : function(rowIndex, columnIndex, item, dataField ) {
                                var calObj = fn_calculateAmt(item.amt , item.inputQty);
                                return Number(calObj.subChanges);
                            }},
                            {dataField : "subChng", headerText : 'GST(0%)', width : '10%', dataType : "numeric", formatString : "#,##0.00", expFunction : function(rowIndex, columnIndex, item, dataField ) {
                                var calObj = fn_calculateAmt(item.amt , item.inputQty);
                                return Number(calObj.taxes);
                            }},
                            {dataField : "totalAmt", headerText : '<spring:message code="sal.text.totAmt" />', width : '10%', dataType : "numeric", formatString : "#,##0.00", expFunction : function(rowIndex, columnIndex, item, dataField ) {
                                var calObj = fn_calculateAmt(item.amt , item.inputQty);
                                return Number(calObj.subTotal);
                            }},
                            {dataField : "stkTypeId" , visible :false},
                            {dataField : "stkId" , visible :false}//STK_ID
                           ];

    //그리드 속성 설정
    var gridPros = {
            showFooter : true,
            usePaging           : true,         //페이징 사용
            pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)
            editable            : false,
            fixedColumnCount    : 1,
            showStateColumn     : true,
            displayTreeOpen     : false,
  //          selectionMode       : "singleRow",  //"multipleCells",
            headerHeight        : 30,
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력
            showRowCheckColumn : true, //checkBox
            softRemoveRowMode : false
    };

    purchaseGridID = GridCommon.createAUIGrid("#item_grid_wrap", posColumnLayout,'', gridPros);  // address list
    AUIGrid.resize(purchaseGridID , 960, 300);

    //
    var footerLayout = [ {
        labelText : "Total(RM)",
        positionField : "#base"
      },{
        dataField : "subTotal",
        positionField : "subTotal",
        operation : "SUM",
        formatString : "#,##0.00",
        style : "aui-grid-my-footer-sum-total2"
      }, {
        dataField : "subChng",
        positionField : "subChng",
        operation : "SUM",
        formatString : "#,##0.00",
        style : "aui-grid-my-footer-sum-total2"
       },{
           dataField : "totalAmt",
           positionField : "totalAmt",
           operation : "SUM",
           formatString : "#,##0.00",
           style : "aui-grid-my-footer-sum-total2"
      }];
   // 푸터 레이아웃 그리드에 설정
   AUIGrid.setFooter(purchaseGridID, footerLayout);
}

//posItmSrchPop -> posSystemPop
function getItemListFromSrchPop(itmList){
    AUIGrid.setGridData(purchaseGridID, itmList);
}

function fn_calculateAmt(amt, qty) {

    var subTotal = 0;
    var subChanges = 0;
    var taxes = 0;

    subTotal = amt * qty;
    subChanges = (subTotal * 100) / 100;
    subChanges = subChanges.toFixed(2); //소수점2반올림
    taxes = subTotal - subChanges;
    taxes = taxes.toFixed(2);

    var retObj = {subTotal : subTotal , subChanges : subChanges , taxes : taxes};

    return retObj;

}


function fn_clearAllGrid(){

    AUIGrid.clearGridData(purchaseGridID);  //purchase TempGridID
    AUIGrid.resize(purchaseGridID , 960, 300);
}
</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.title.text.posRequest" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a id="_systemClose"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<ul class="right_btns">
     <li><p class="btn_blue2"><a id="_purchBtn"><spring:message code="sal.title.text.purchItems" /></a></p></li>
    <li><p class="btn_blue2"><a id="_posReqSaveBtn"><spring:message code="sal.btn.save" /></a></p></li>
</ul>

<aside class="title_line"><!-- title_line start -->
<h2><spring:message code="sal.title.text.posInfo" /></h2>
</aside><!-- title_line end -->
<form id="_sysForm">
<!-- HIDDEN VALUES -->
<input type="hidden" name="hidLocId" id="_hidLocId" value="${locMap.whLocId}">
<input type="hidden" name="cmbWhBrnchIdPop" value="${memCodeMap.brnch}">

<input type="hidden" name="posReason" id="_posReason">
<input type="hidden" name="payResult" id="_payResult">
<input type="hidden" name="areaId" id="areaId">


<input type="hidden"  id="_posRemark" name="posRemark" />
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.title.posType" /></th>
    <td>
    <select class="w100p" id="_insPosModuleType" name="insPosModuleType"></select>
    </td>
    <th scope="row"><spring:message code="sal.title.text.posSalesType" /></th>
    <td>
    <select class="w100p" id="_insPosSystemType" name="insPosSystemType"></select>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2><spring:message code="sal.title.text.particInfo" /></h2>
</aside><!-- title_line end -->

<div id="_divOth">
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
     <th scope="row"><spring:message code="sal.text.custName" /></th>
     <td colspan="3">
        <input type="text" title="" placeholder="CustomerName" class="w100p"  value="CASH" name="insPosCustName" id="_insPosCustName"/>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.areaSearch" /></th>
    <td colspan="3">
        <input type="text" title="" id="searchSt" name="searchSt" placeholder="" class="" /><a href="#" onclick="fn_addrSearch()" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.addressDetail" /></th>
    <td colspan="3">
        <input type="text" title="" id="addrDtl" name="addrDtl" placeholder="Detail Address" class="w100p"  />
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.street" /></th>
    <td colspan="3">
        <input type="text" title="" id="streetDtl" name="streetDtl" placeholder="Detail Address" class="w100p"  />
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.area4" /><span class="must">*</span></th>
    <td colspan="3">
        <select class="w100p" id="mArea"  name="mArea" onchange="javascript : fn_getAreaId()"></select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.city2" /><span class="must">*</span></th>
    <td>
    <select class="w100p" id="mCity"  name="mCity" onchange="javascript : fn_selectCity(this.value)"></select>
    </td>
    <th scope="row"><spring:message code="sal.text.postCode3" /><span class="must">*</span></th>
    <td>
    <select class="w100p" id="mPostCd"  name="mPostCd" onchange="javascript : fn_selectPostCode(this.value)"></select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.state1" /><span class="must">*</span></th>
    <td>
    <select class="w100p" id="mState"  name="mState" onchange="javascript : fn_selectState(this.value)"></select>
    </td>
    <th scope="row"><spring:message code="sal.text.country" /><span class="must">*</span></th>
    <td>
    <input type="text" title="" id="mCountry" name="mCountry" placeholder="" class="w100p readonly" readonly="readonly" value="Malaysia"/>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.remark" /></th>
    <td colspan="3">
        <input type="text" title="" placeholder="" class="w100p"  id="_posRemarkOth" />
    </td>
</tr>
</tbody>
</table><!-- table end -->
</div>

<div id="_divHq" style="display: none;">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.memberCode" /></th>
    <td>
        <input id="salesmanPopCd" name="salesmanPopCd" type="text" title="" placeholder="" class=""  value="${memCodeMap.memCode}"/>
        <input id="hiddenSalesmanPopId" name="salesmanPopId" type="hidden"  value="${memCodeMap.memId}"/>
        <a id="memBtnPop" href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.brnchWarehouse" /></th>
    <td>
         <select  id="_cmbWhBrnchIdPop" name="cmbWhBrnchIdPop"></select>
        <input type="text" disabled="disabled" id="cmbWhIdPop"  value="${locMap.whLocDesc}">
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.recvDate" /></th>
    <td>
        <input type="text" title="기준년월" class="j_date w100p" placeholder="MM/YYYY" readonly="readonly"  id="_recvDate" name="recvDate"/>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.remark" /></th>
    <td>
        <input type="text" title="" placeholder="" class="w100p" id="_posRemarkHq"  />
    </td>
</tr>
</tbody>
</table><!-- table end -->


</div>
</form>
<aside class="title_line"><!-- title_line start -->
<h2><spring:message code="sal.title.text.chargeBal" /></h2>
</aside><!-- title_line end -->

<ul class="right_btns">
    <li><p class="btn_grid"><a id="_purcDelBtn"><spring:message code="sal.btn.del" /></a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="item_grid_wrap" style="width:100%; height:300px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->