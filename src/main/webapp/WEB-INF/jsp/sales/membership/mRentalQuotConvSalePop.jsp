<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
//popup 크기
var option = {
        width : "1200px",   // 창 가로 크기
        height : "500px"    // 창 세로 크기
};

    //AUIGrid 생성 후 반환 ID
    var myGridID;
    
    $(document).ready(function(){
        
    	$("#_inputMemCode").attr("readonly" , "readonly");
    	$("#_memConfirm").hide();
    	$("#_memSearch").hide();
    	
        // AUIGrid 그리드를 생성합니다.
        createAUIGrid();
    
        fn_filterChargeListJsonAjax();
        $("#chkDiv").hide();
        if($("#appTypeId").val() != 66  && $("#custBillId").val() == 0){
        	$("#groupDiv").show();
        }else{
            $("#groupDiv").hide();
        }
        $("#radio1").hide();
        $("#radio2").hide();
        
        $("#cardDiv").hide();
        $("#directDiv").hide();
        
        //confirm click(Member Confirm)
        $("#_memConfirm").click(function() {
            
            var inputVal = $("#_inputMemCode").val();
            fn_getMemCodeConfirm(inputVal);
            
        });
        
        //Member Search Pop
        $("#_memSearch").click(function() {
            Common.popupDiv('/sales/ccp/searchMemberPop.do' , $('#_searchForm').serializeJSON(), null , true, '_searchDiv');
            
        });
        
        $('#thrdPartyBtn').click(function() {
            //Common.searchpopupWin("searchForm", "/common/customerPop.do","");
            Common.popupDiv("/common/customerPop.do", {callPrgm : "ORD_REGISTER_PAY_3RD_PARTY"}, null, true);
        });
        
        $('#addCreditCardBtn').click(function() {
            var vCustId = $('#thrdParty').is(":checked") ? $('#hiddenThrdPartyId').val() : $('#hiddenCustId').val();
            Common.popupDiv("/sales/customer/customerCreditCardAddPop.do", {custId : vCustId}, null, true);
        });
        
        $('#selCreditCardBtn').click(function() {
            var vCustId = $('#thrdParty').is(":checked") ? $('#hiddenThrdPartyId').val() : $('#hiddenCustId').val();
            //Common.popupWin("searchForm", "/sales/customer/customerCreditCardSearchPop.do", {width : "1200px", height : "630x"});
            Common.popupDiv("/sales/customer/customerCreditCardSearchPop.do", {custId : vCustId, callPrgm : "ORD_REGISTER_PAYM_CRC"}, null, true);
        });
        
        //Add New Bank Account
        $('#btnAddBankAccount').click(function() {
            var vCustId = $('#thrdParty').is(":checked") ? $('#hiddenThrdPartyId').val() : $('#hiddenCustId').val();
            Common.popupDiv("/sales/customer/customerBankAccountAddPop.do", {custId : vCustId}, null, true);
        });
      
        //Select Another Bank Account
        $('#btnSelBankAccount').click(function() {
            var vCustId = $('#thrdParty').is(":checked") ? $('#hiddenThrdPartyId').val() : $('#hiddenCustId').val();
            Common.popupDiv("/sales/customer/customerBankAccountSearchPop.do", {custId : vCustId, callPrgm : "ORD_REGISTER_BANK_ACC"});
        });
        
        //Billing Group
        $('#billGrpBtn').click(function() {
            //Common.popupWin("searchForm", "/customerBillGrpSearchPop.do", {width : "1200px", height : "630x"});
            Common.popupDiv("/sales/customer/customerBillGrpSearchPop.do", {custId : $('#hiddenCustId').val(), callPrgm : "ORD_REGISTER_BILL_GRP"}, null, true);
        });
        
    });
    
    doGetCombo('/common/selectCodeList.do', '19', '','cmbRentPaymode', 'S' , '');   // cmbRentPaymode Combo Box
    
    function createAUIGrid() {
        // AUIGrid 칼럼 설정
        
        // 데이터 형태는 다음과 같은 형태임,
        //[{"id":"#Cust0","date":"2014-09-03","name":"Han","country":"USA","product":"Apple","color":"Red","price":746400}, { .....} ];
        var columnLayout = [ {
                dataField : "stkCode",
                headerText : "Code",
                width : 100,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "stkDesc",
                headerText : "Description",
                editable : false,
                style: 'left_style'
            }, {
                dataField : "qotatItmChrg",
                headerText : "Filter Charges",
                width : 110,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "qotatItmTxs",
                headerText : "Filter Taxes",
                width : 110,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "qotatItmAmt",
                headerText : "Filter Amount",
                width : 110,
                editable : false,
                style: 'left_style'
            },{
                dataField : "qotatItmAmt",
                headerText : "Charge Price",
                width : 120,
                editable : false,
                style: 'left_style'
            },{
                dataField : "qotatItmExpDt",
                headerText : "Last Change Date",
                width : 100,
                dataType : "date",
                formatString : "dd-mm-yyyy" ,
                editable : false,
                style: 'left_style'
            }];
       
        // 그리드 속성 설정
        var gridPros = {
            // 페이징 사용       
            usePaging : true,
            // 한 화면에 출력되는 행 개수 20(기본값:20)
            pageRowCount : 10,
            editable : false,
            fixedColumnCount : 1,
            showStateColumn : false, 
            displayTreeOpen : true,
            selectionMode : "multipleCells",
            headerHeight : 30,
            // 그룹핑 패널 사용
            useGroupingPanel : true,
            // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            skipReadonlyColumns : true,
            // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            wrapSelectionMove : true,
            // 줄번호 칼럼 렌더러 출력
            showRowNumColumn : true,
            groupingMessage : "Here groupping"
        };
        
        myGridID = AUIGrid.create("#filter_grid_wrap", columnLayout, gridPros);
    }
    
    //Get Contact by Ajax
    function fn_filterChargeListJsonAjax(){
        Common.ajax("GET", "/sales/membershipRentalQut/cnvrToSalesfilterChgJsonList",$("#paramForm").serialize(), function(result) {
            AUIGrid.setGridData(myGridID, result);
        });
    }
    
    //resize func (tab click)
    function fn_resizefunc(gridName){ // 
        AUIGrid.resize(gridName, 950, 300);
   }
    
    function checkboxDivChg(){

    	if($('input:checkbox[id="thrdParty"]').is(":checked") == true){
    		$("#chkDiv").show();
        }else{
            $("#chkDiv").hide();
        }
    }

    function fn_groupChg(val){
    	if(val == 'N'){
    		$("#radio1").show();
    		$("#radio2").hide();
    	}else if(val == 'E'){
    		$("#radio1").hide();
            $("#radio2").show();
    	}
    }
    
    function fn_payModeChg(){
    	if($("#cmbRentPaymode").val() == ''){
            $("#cardDiv").hide();
            $("#directDiv").hide();
        }else if($("#cmbRentPaymode").val() == '131'){
    		$("#cardDiv").show();
            $("#directDiv").hide();
    	}else if($("#cmbRentPaymode").val() == '132'){
    		$("#cardDiv").hide();
            $("#directDiv").show();
    	}else{
    		$("#cardDiv").hide();
            $("#directDiv").hide();
    	}
    }
    
    function fn_getMemCodeConfirm(inputVal){
        
        $.ajax({
            
            type : "GET",
            url : getContextPath() + "/sales/ccp/getMemCodeConfirm",
            contentType: "application/json;charset=UTF-8",
            crossDomain: true,
            data: {inputMemCode : inputVal},
            dataType: "json",
            success : function (data) {
                
                $("#_inputMemCode").val(data.memCode);
                $("#_hiddenInputMemCode").val(data.memCode);
                $("#_govAgMemId").val(data.memId);
                fn_selected();
            },
            error : function (data) {
                if(data == null){               //error
                    Common.alert("fail to Load DB");
                }else{                            // No data
                    Common.alert("Unable to find ["+inputVal+"] in system. Please ensure you key in the correct member code.");
                }
            }
        });
    }
    
    function fn_newParty(){
        Common.popupWin("paramForm", "/sales/customer/customerRegistPop.do", option);
    }
    
    function fn_reselect(){
    	$("#_inputMemCode").val('');
    	$("#_inputMemName").text('');
        $("#_hiddenInputMemCode").val('');
        $("#_inputMemCode").attr({"readonly" : false , "class" : ""});
        $("#_memReSelected").hide();
//        $("#_memConfirm").css("display" , "");
//        $("#_memSearch").css("display" , "");
        
//        $("#_inputMemCode").attr("readonly" , "readonly");
        $("#_memConfirm").show();
        $("#_memSearch").show();
    }
    
    function fn_selected(){
        
        $("#_inputMemCode").attr({"readonly" : "readonly" , "class" : "w100 readonly"});
        $("#_memReSelected").show();
        $("#_memConfirm").hide();
        $("#_memSearch").hide();
        $("#_closeMemPop").click();
      
    }
    
    function fn_loadCreditCard(crcId, custOriCrcNo, custCrcNo, custCrcType, custCrcName, custCrcExpr, custCRCBank, custCrcBankId, crcCardType) {
    	$('#hiddenRentPayCRCId').val(crcId);
        $('#rentPayCRCNo').val(custOriCrcNo);
        $('#hiddenRentPayEncryptCRCNoId').val(custCrcNo);
        $('#rentPayCRCType').val(custCrcType);
        $('#rentPayCRCName').val(custCrcName);
        $('#rentPayCRCExpiry').val(custCrcExpr);
        $('#rentPayCRCBank').val(custCRCBank);
        $('#hiddenRentPayCRCBankId').val(custCrcBankId);
        $('#rentPayCRCCardType').val(crcCardType);
    }
    
    function fn_loadBankAccountPop(bankAccId) {
//        fn_clearRentPaySetDD();
        fn_loadBankAccount(bankAccId);
        
        $('#sctDirectDebit').removeClass("blind");

        if(!FormUtil.IsValidBankAccount($('#hiddenRentPayBankAccID').val(), $('#rentPayBankAccNo').val())) {
//            fn_clearRentPaySetDD();
            $('#sctDirectDebit').removeClass("blind");
            Common.alert("Invalid Bank Account" + DEFAULT_DELIMITER + "<b>Invalid account for auto debit.</b>");
        }
    }
    
    function fn_loadBankAccount(bankAccId) {
        console.log("fn_loadBankAccount START");
        
        Common.ajax("GET", "/sales/order/selectCustomerBankDetailView.do", {getparam : bankAccId}, function(rsltInfo) {

            if(rsltInfo != null) {
                console.log("fn_loadBankAccount Setting");
                
                $("#hiddenRentPayBankAccID").val(rsltInfo.custAccId);
                $("#rentPayBankAccNo").val(rsltInfo.custAccNo);
                $("#rentPayBankAccNoEncrypt").val(rsltInfo.custEncryptAccNo);
                $("#rentPayBankAccType").val(rsltInfo.codeName);
                $("#accName").val(rsltInfo.custAccOwner);
                $("#accBranch").val(rsltInfo.custAccBankBrnch);
                $("#accBank").val(rsltInfo.bankCode + ' - ' + rsltInfo.bankName);
                $("#hiddenAccBankId").val(rsltInfo.custAccBankId);
            }
        });
    }
    
    function fn_loadBillingGroup(billGrpId, custBillGrpNo, billType, billAddrFull, custBillRem, custBillAddId) {
        $('#hiddenBillGrpId').removeClass("readonly").val(billGrpId);
        $('#billGrp').removeClass("readonly").val(custBillGrpNo);
        $('#billType').removeClass("readonly").val(billType);
        $('#billAddr').removeClass("readonly").val(billAddrFull);
        $('#billRem').removeClass("readonly").val(custBillRem);

    }
    
    function fn_loadThirdParty(custId, sMethd) {

//        fn_clearRentPayMode();
//        fn_clearRentPay3thParty();
//        fn_clearRentPaySetCRC();
//        fn_clearRentPaySetDD();

        if(custId != $('#hiddenCustId').val()) {
            Common.ajax("GET", "/sales/customer/selectCustomerJsonList", {custId : custId}, function(result) {

            if(result != null && result.length == 1) {

                var custInfo = result[0];

                $('#hiddenThrdPartyId').val(custInfo.custId)
                $('#thrdPartyId').val(custInfo.custId)
                $('#thrdPartyType').val(custInfo.codeName1)
                $('#thrdPartyName').val(custInfo.name)
                $('#thrdPartyNric').val(custInfo.nric)

                $('#thrdPartyId').removeClass("readonly");
                $('#thrdPartyType').removeClass("readonly");
                $('#thrdPartyName').removeClass("readonly");
                $('#thrdPartyNric').removeClass("readonly");
            }
            else {
                if(sMethd == 2) {
                    Common.alert('<b>Third party not found.<br />'
                               + 'Your input third party ID : ' + custId + '</b>');
                }
            }
        });
        }
        else {
            Common.alert('<b>Third party and customer cannot be same person/company.<br />'
                       + 'Your input third party ID : ' + custId + '</b>');
        }

        $('#sctThrdParty').removeClass("blind");
    }
    
    function fn_ctsSave(){
    	if($('input:checkbox[id="thrdParty"]').is(":checked") == true){
            $("#chkBoxThrdParty").val('1');
        }else{
            $("#chkBoxThrdParty").val('0');
        }
    	
    	if($("#cmbRentPaymode").val() == ""){
    		Common.alert("Please select Rental Paymode");
    		return false;
    	}
    	
    	Common.ajax("GET", "/sales/membershipRentalQut/saveCnvrToSale.do", $("#mSaveForm").serialize(), function(result){
            //result alert and reload
            Common.alert("Quotation has successfully converted to sales.<br />", fn_success);
        }, function(jqXHR, textStatus, errorThrown) {
            try {
                console.log("status : " + jqXHR.status);
                console.log("code : " + jqXHR.responseJSON.code);
                console.log("message : " + jqXHR.responseJSON.message);
                console.log("detailMessage : " + jqXHR.responseJSON.detailMessage);
    
                //Common.alert("Failed to order invest reject.<br />"+"Error message : " + jqXHR.responseJSON.message + "</b>");
                Common.alert("Unable to retrieve exchange request in system.");
                }
            catch (e) {
                console.log(e);
                alert("Saving data prepration failed.");
            }
            alert("Fail : " + jqXHR.responseJSON.message);
        });
    }
    
    function fn_success(){
    	fn_selectListAjax();
    	$("#cnvrClose").click();
    }
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Rental Membership - Convert To Sales</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="cnvrClose">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1">
    <li><a href="#" class="on">Package Info</a></li>
    <li><a href="#">Order Info</a></li>
    <li><a href="#">Contact Info</a></li>
    <li><a href="#" onclick="javascript: fn_resizefunc(myGridID)">Filter Charge Info</a></li>
</ul>

<article class="tap_area"><!-- tap_area start -->

<form id="paramForm" name="paramForm" method="GET">
<input type="hidden" id="qotatId" name="qotatId" value="${qotatId }">
<input type="hidden" id="appTypeId" name="appTypeId" value="${orderInfo.appTypeId }">
<input type="hidden" id="custBillId" name="custBillId" value="${orderInfo.custBillId }">
</form>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:170px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Quotation No</th>
    <td><span>${packageInfo.qotatRefNo }</span></td>
    <th scope="row">Creator Date</th>
    <td><span>${fn:substring(packageInfo.qotatCrtDt, 8, 10)}/${fn:substring(packageInfo.qotatCrtDt, 5, 7)}/${fn:substring(packageInfo.qotatCrtDt, 0, 4)}</span></td>
    <th scope="row">Creator</th>
    <td><span>${packageInfo.userName }</span></td>
</tr>
<tr>
    <th scope="row">Membership No</th>
    <td><span></span></td>
    <th scope="row">Valid Date</th>
    <td colspan="3"><span>${fn:substring(packageInfo.qotatValIdDt, 8, 10)}/${fn:substring(packageInfo.qotatValIdDt, 5, 7)}/${fn:substring(packageInfo.qotatValIdDt, 0, 4)}</span></td>
</tr>
<tr>
    <th scope="row">Duration</th>
    <td><span>${packageInfo.qotatCntrctDur } month(s)</span></td>
    <th scope="row">Package</th>
    <td colspan="3"><span>${packageInfo.srvCntrctPacDesc }</span></td>
</tr>
<tr>
    <th scope="row">Total Amount</th>
    <td><span>${packageInfo.qotatTotalAmt }</span></td>
    <th scope="row">Rental Amount</th>
    <td><span>${packageInfo.qotatRentalAmt }</span></td>
    <th scope="row">Filter Amount</th>
    <td><span>${packageInfo.qotatExpFilterAmt }</span></td>
</tr>
<tr>
    <th scope="row">Package Promotion</th>
    <td colspan="5"><span>${packageInfo.packagePromoDesc }</span></td>
</tr>
<tr>
    <th scope="row">Filter Promotion</th>
    <td colspan="3"><span>${packageInfo.filterPromoDesc }</span></td>
    <th scope="row">BS Frequency</th>
    <td><span>${packageInfo.srvCntrctFormNo }</span></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Order No</th>
    <td><span>${orderInfo.ordNo }</span></td>
    <th scope="row">Order Date</th>
    <td>
        <span><if test="${orderInfo.ordDt } != null">
            ${fn:substring(orderInfo.ordDt, 8, 10)}/${fn:substring(orderInfo.ordDt, 5, 7)}/${fn:substring(orderInfo.ordDt, 0, 4)}
        </if></span>
    </td>
    <th scope="row">Order Status</th>
    <td><span>${orderInfo.ordStusName }</span></td>
</tr>
<tr>
    <th scope="row">Product Category</th>
    <td colspan="3"><span>${orderInfo.stkCtgryName }</span></td>
    <th scope="row">Application Type</th>
    <td><span>${orderInfo.appTypeDesc }</span></td>
</tr>
<tr>
    <th scope="row">Product Code</th>
    <td><span>${orderInfo.stockCode }</span></td>
    <th scope="row">Product Name</th>
    <td colspan="3"><span>${orderInfo.stockDesc }</span></td>
</tr>
<tr>
    <th scope="row">Customer ID</th>
    <td><span>${orderInfo.custId }</span></td>
    <th scope="row">NRIC/Company No</th>
    <td colspan="3"><span>${orderInfo.custNric }</span></td>
</tr>
<tr>
    <th scope="row">Customer Name</th>
    <td colspan="5"><span>${orderInfo.custName }</span></td>
</tr>
<tr>
    <th scope="row">Last Membership</th>
    <td><span>${fn:substring(orderInfo2nd.srvPrdExprDt, 8, 10)}/${fn:substring(orderInfo2nd.srvPrdExprDt, 5, 7)}/${fn:substring(orderInfo2nd.srvPrdExprDt, 0, 4)}</span></td>
    <th scope="row">Expire Date</th>
    <td colspan="3"><span>${orderInfo2nd.srvCntrctPacDesc }</span></td>
</tr>
<tr>
    <th scope="row">Install Address</th>
    <td colspan="5"><span>${addrInfo.fullAddr }</span></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->
<!-- 
<ul class="left_btns mb10">
    <li><p class="btn_blue"><a href="#">Other Contact Person</a></p></li>
    <li><p class="btn_blue"><a href="#">New Contact Person</a></p></li>
</ul>
 -->
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Name</th>
    <td colspan="5"><span>${cntcInfo.name }</span></td>
</tr>
<tr>
    <th scope="row">NRIC</th>
    <td><span>${cntcInfo.nric }</span></td>
    <th scope="row">Gender</th>
    <td><span>${cntcInfo.gender }</span></td>
    <th scope="row">Race</th>
    <td><span>${cntcInfo.codename1 }</span></td>
</tr>
<tr>
    <th scope="row">Mobile No</th>
    <td><span>${cntcInfo.telM1 }</span></td>
    <th scope="row">Office No</th>
    <td><span>${cntcInfo.telO }</span></td>
    <th scope="row">Residence No</th>
    <td><span>${cntcInfo.telR }</span></td>
</tr>
<tr>
    <th scope="row">Fax No</th>
    <td><span>${cntcInfo.telf }</span></td>
    <th scope="row">Email</th>
    <td colspan="3"><span>${cntcInfo.email }</span></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="filter_grid_wrap" style="width:100%; height:280px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

</section><!-- tap_wrap end -->

<aside class="title_line"><!-- title_line start -->
<h3>Rental Payment Information</h3>
</aside><!-- title_line end -->

<form id="mSaveForm" name="mSaveForm" method=GET>
<input type="hidden" id="hiddenCustId" name="hiddenCustId" value="${custId }">
<input type="hidden" id="srvCntrctQuotId" name="srvCntrctQuotId" value="${qotatId }">
<input type="hidden" id="hiddenOrdId" name="hiddenOrdId" value="${packageInfo.qotatOrdId }">
<input type="hidden" id="hiddenQotatPckgId" name="hiddenQotatPckgId" value="${packageInfo.qotatPckgId }">
<input type="hidden" id="rentalDur" name="rentalDur" value="${packageInfo.qotatCntrctDur }">
<input type="hidden" id="qotatSalesmanId" name="qotatSalesmanId" value="${packageInfo.qotatSalesmanId }">
<input type="hidden" id="qotatPacPromoId" name="qotatPacPromoId" value="${packageInfo.qotatPacPromoId }">
<input type="hidden" id="rentalAmt" name="rentalAmt" value="${packageInfo.qotatRentalAmt }">
<input type="hidden" id="filterAmt" name="filterAmt" value="${packageInfo.qotatExpFilterAmt }">
<input type="hidden" id="chkBoxThrdParty" name="chkBoxThrdParty" >
<input type="hidden" id="hiddenOrdNo" name="hiddenOrdNo" value="${orderInfo.ordNo }">
<input type="hidden" id="qotatCrtUserId" name="qotatCrtUserId" value="${packageInfo.qotatCrtUserId }">
<section class="search_table mt20"><!-- search_table start -->

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
    <th scope="row">Pay By Third Party</th>
    <td colspan="3"><input type="checkbox" id="thrdParty" name="thrdParty" onclick="checkboxDivChg();"></td>
</tr>
</tbody>
</table>
<!-- Check Start -->
<div id="chkDiv">
<table class="type1">
<colgroup>
    <col style="width:170px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <td colspan="4">
        <aside class="title_line"><!-- title_line start -->
        <h3>Third Party</h3>
        </aside><!-- title_line end -->

        <ul class="right_btns w100p mb10">
            <li><p class="btn_sky small"><a href="#" onclick="fn_newParty()">Add New Third Party</a></p></li>
        </ul>
    </td>
</tr>
<tr>
    <th scope="row">Customer ID<span class="must">*</span></th>
    <td><input id="thrdPartyId" name="thrdPartyId" type="text" title="" placeholder="Third Party ID" class="" />
        <a href="#" class="search_btn" id="thrdPartyBtn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
        <input id="hiddenThrdPartyId" name="hiddenThrdPartyId" type="hidden" title="" placeholder="Third Party ID" class="" /></td>
    <th scope="row">Type</th>
    <td><input id="thrdPartyType" name="thrdPartyType" type="text" title="" placeholder="Costomer Type" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">Name</th>
    <td><input id="thrdPartyName" name="thrdPartyName" type="text" title="" placeholder="Customer Name" class="w100p readonly" readonly/></td>
    <th scope="row">NRIC/Company No</th>
    <td><input id="thrdPartyNric" name="thrdPartyNric" type="text" title="" placeholder="NRIC/Company Number" class="w100p readonly" readonly/></td>
</tr>
</tbody>
</table>
</div>
<!-- Check End -->
<table class="type1">
<colgroup>
    <col style="width:170px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Rental Paymode<span class="must">*</span></th>
    <td>
    <select class="w100p" id="cmbRentPaymode" name="cmbRentPaymode" onchange="fn_payModeChg()">
    </select>
    </td>
    <th scope="row">NRIC on DD/Passbook</th>
    <td><input type="text" id="rentPayIc" name="rentPayIc" title="" placeholder="NRIC on DD/Passbook" class="w100p" /></td>
</tr>
</tbody>
</table>
<!-- Select Direct Debit Start -->
<div id="directDiv">
<table class="type1">
<colgroup>
    <col style="width:170px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <td colspan="4">
        <aside class="title_line"><!-- title_line start -->
        <h3>Direct Debit</h3>
        </aside><!-- title_line end -->

        <ul class="right_btns w100p mb10">
            <li><p class="btn_sky small"><a href="#" id="btnAddBankAccount">Add New Bank Account</a></p></li>
            <li><p class="btn_sky small"><a href="#" id="btnSelBankAccount">Select Another Bank Account</a></p></li>
        </ul>
    </td>
</tr>
<tr>
    <th scope="row">Account Number<span class="must">*</span></th>
    <td><input id="rentPayBankAccNo" name="rentPayBankAccNo" type="text" title="" placeholder="Account Number readonly" class="w100p readonly" readonly/>
        <input id="hiddenRentPayBankAccID" name="hiddenRentPayBankAccID" type="hidden" /></td>
    <th scope="row">Account Type</th>
    <td><input id="rentPayBankAccType" name="rentPayBankAccType" type="text" title="" placeholder="Account Type readonly" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">Account Holder</th>
    <td><input id="accName" name="accName" type="text" title="" placeholder="Account Holder" class="w100p readonly" readonly/></td>
    <th scope="row">Issue Bank Branch</th>
    <td><input id="accBranch" name="accBranch" type="text" title="" placeholder="Issue Bank Branch" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">Issue Bank</th>
    <td colspan=3><input id="accBank" name="accBank" type="text" title="" placeholder="Issue Bank" class="w100p readonly" readonly/>
        <input id="hiddenAccBankId" name="hiddenAccBankId" type="hidden" /></td>
</tr>
</tbody>
</table>
</div>
<!-- Select Direct Debit End -->
<!-- Select Credit Card Start -->
<div id="cardDiv">
<table class="type1">
<colgroup>
    <col style="width:170px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <td colspan="4">
        <aside class="title_line"><!-- title_line start -->
        <h3>Credit Card</h3>
        </aside><!-- title_line end -->

        <ul class="right_btns w100p mb10">
            <li><p class="btn_sky small"><a href="#" id="addCreditCardBtn">Add New Credit Card</a></p></li>
            <li><p class="btn_sky small"><a href="#" id="selCreditCardBtn">Select Another Credit Card</a></p></li>
        </ul>
    </td>
</tr>
<tr>
    <th scope="row">Credit Card Number<span class="must">*</span></th>
    <td>
        <input id="rentPayCRCNo" name="rentPayCRCNo" type="text" title="" placeholder="Credit Card Number" class="w100p readonly" readonly/>
        <input id="hiddenRentPayCRCId" name="rentPayCRCId" type="hidden" />
        <input id="hiddenRentPayEncryptCRCNoId" name="hiddenRentPayEncryptCRCNoId" type="hidden" />
    </td>
    <th scope="row">Credit Card Type</th>
    <td>
        <input id="rentPayCRCType" name="rentPayCRCType" type="text" title="" placeholder="Credit Card Type" class="w100p readonly" readonly/>
    </td>
</tr>
<tr>
    <th scope="row">Name On Card</th>
    <td>
        <input id="rentPayCRCName" name="rentPayCRCName" type="text" title="" placeholder="Name On Card" class="w100p readonly" readonly/>
    </td>
    <th scope="row">Expiry</th>
    <td>
        <input id="rentPayCRCExpiry" name="rentPayCRCExpiry" type="text" title="" placeholder="Credit Card Expiry" class="w100p readonly" readonly/>
    </td>
</tr>
<tr>
    <th scope="row">Issue Bank</th>
    <td>
        <input id="rentPayCRCBank" name="rentPayCRCBank" type="text" title="" placeholder="Issue Bank" class="w100p readonly" readonly/>
        <input id="hiddenRentPayCRCBankId" name="rentPayCRCBankId" type="hidden" title="" class="w100p" />
    </td>
    <th scope="row">Card Type</th>
    <td>
        <input id="rentPayCRCCardType" name="rentPayCRCCardType" type="text" title="" placeholder="Card Type" class="w100p readonly" readonly/>
    </td>
</tr>
<!-- Select Credit Card End -->
</tbody>
</table><!-- table end -->
</div>

</section><!-- search_table end -->

<aside class="title_line"><!-- title_line start -->
<h3>Rental Billing Group</h3>
</aside><!-- title_line end -->

<section class="search_table mt20"><!-- search_table start -->

<div id="groupDiv">
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
    <th scope="row">Group Option<span class="must"></span></th>
    <td colspan="3">
    <label><input type="radio" id="billingGroup" name="billingGroup" value="N" onclick="fn_groupChg('N')"/><span>New Billing Group</span></label>
    <label><input type="radio" id="billingGroup" name="billingGroup" value="E" onclick="fn_groupChg('E')"/><span>Existing Billing Group</span></label>
    </td>
</tr>
</tbody>
</table>
</div>
<!-- Radio1 Start -->
<div id="radio1">
<table class="type1">
<colgroup>
    <col style="width:170px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row" rowspan="3">Billing Method</th>
    <td colspan="3">
        <label><input type="checkbox" /><span>Post</span></label><br>
    </td>
</tr>
<tr>
    <td colspan="3">
        <label><input type="checkbox" /><span>SMS</span></label><br>
    </td>
</tr>
<tr>
    <td>
        <label><input type="checkbox" /><span>E-Statement</span></label>
    </td>
    <th scope="row">Email</th>
    <td><input type="text" title="" placeholder="Email Address" class="w100p" /></td>
</tr>
</tbody>
</table>
</div>
<!-- Radio1 End -->
<!-- Radio2 Start -->
<div id="radio2">
<table class="type1">
<colgroup>
    <col style="width:170px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <td colspan="4">
        <aside class="title_line"><!-- title_line start -->
        <h3>Billing Group Selection</h3>
        </aside><!-- title_line end -->
    </td>
</tr>
<tr>
    <th scope="row">Billing Group<span class="must">*</span></th>
    <td><input id="billGrp" name="billGrp" type="text" title="" placeholder="Billing Group" class="readonly" readonly/><a id="billGrpBtn" href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
        <input id="hiddenBillGrpId" name="billGrpId" type="hidden" /></td>
    <th scope="row">Billing Type<span class="must">*</span></th>
    <td><input id="billType" name="billType" type="text" title="" placeholder="Billing Type" class="w100p readonly" readonly/></td>
</tr>
<tr>
    <th scope="row">Billing Address</th>
    <td colspan="3"><textarea id="billAddr" name="billAddr" cols="20" rows="5" readonly></textarea></td>
</tr>
</tbody>
</table>
</div>
<!-- Radio2 End -->
<div id="radioNo">
<table class="type1">
<colgroup>
    <col style="width:170px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Remark</th>
    <td colspan="3"><textarea id="billRem" name="billRem" cols="20" rows="5" readonly></textarea></td>
</tr>
</tbody>
</table><!-- table end -->
</div>

</section><!-- search_table end -->

<aside class="title_line"><!-- title_line start -->
<h3>Sales Person Information</h3>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->

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
    <th scope="row">Sales Person Code</th>
    <td>
        <input type="text" id="_inputMemCode" name="inputMemCode" title="" value="${packageInfo.memCode }" placeholder="" class=""/>
        <input type="hidden" id="_hiddenInputMemCode" >
        <input type="hidden" id="_govAgMemId" name="govAgMemId">
        <p class="btn_sky"><a href="#" id="_memConfirm">Confirm</a></p> 
        <p class="btn_sky"><a href="#" id="_memSearch">Search</a></p>
        <p class="btn_sky"><a  id="_memReSelected" onclick="fn_reselect()">Reselect</a></p>
    </td>
    <th scope="row">Sales Person Name</th>
    <td><span id="_getMemName">${packageInfo.memName }</span></td>
</tr>
</tbody>
</table><!-- table end -->

</section><!-- search_table end -->

<aside class="title_line"><!-- title_line start -->
<h3>PO Information</h3>
</aside><!-- title_line end -->

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
    <th scope="row">PO No</th>
    <td><input type="text" id="poNo" name="poNo" title="" placeholder="" class="w100p" /></td>
    <td colspan="2"></td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns mt20">
    <li><p class="btn_blue2"><a href="#" onclick="fn_ctsSave()">Convert to Sales</a></p></li>
</ul>

</form>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
