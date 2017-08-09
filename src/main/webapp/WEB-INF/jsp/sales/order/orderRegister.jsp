<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<head>
<script type="text/javaScript" language="javascript">

    var docGridID;

	$(document).ready(function(){
	    //AUIGrid 그리드를 생성합니다.
	    createAUIGrid();
	    
	    fn_selectDocSubmissionList();

        doGetComboOrder('/common/selectCodeList.do', '10', 'CODE_ID',   '', 'appType',     'S', ''); //Common Code
        doGetComboOrder('/common/selectCodeList.do', '19', 'CODE_NAME', '', 'rentPayMode', 'S', ''); //Common Code
	    doGetComboSepa ('/common/selectBranchCodeList.do', '5',  ' - ', '', 'dscBrnchId',  'S', ''); //Branch Code
	    
	    //Payment Channel, Billing Detail TAB Visible False처리
        fn_tabOnOffSet('PAY_CHA', 'HIDE');
        fn_tabOnOffSet('BIL_DTL', 'HIDE');
	});

    function createAUIGrid() {
        
        //AUIGrid 칼럼 설정
        var columnLayout = [{
                dataField   : "typeDesc",   headerText  : "Document",
                editable    : false,        style       : 'left_style'
            }, {
                dataField   : "codeId",     visible     : false
            }];

        //그리드 속성 설정
        var gridPros = {
            usePaging           : true,         //페이징 사용
            pageRowCount        : 40,           //한 화면에 출력되는 행 개수 20(기본값:20)            
            editable            : true,            
            fixedColumnCount    : 0,            
            showStateColumn     : false,     
            showRowCheckColumn  : true,        
            displayTreeOpen     : false,            
            selectionMode       : "singleRow",  //"multipleCells",            
            headerHeight        : 30,       
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력    
            noDataMessage       : "No order found.",
            groupingMessage     : "Here groupping"
        };
        
        docGridID = GridCommon.createAUIGrid("grid_doc_wrap", columnLayout, "", gridPros);
    }
    
    // 리스트 조회.
    function fn_selectDocSubmissionList() {
        
        $("#searchTypeCodeId").val("248");
        
        Common.ajax("GET", "/common/selectDocSubmissionList.do", $("#searchForm").serialize(), function(result) {
            AUIGrid.setGridData(docGridID, result);
        });
    }
    
	function fn_loadCustomer(custId){
	
	    $("#searchCustId").val(custId);
	
	    Common.ajax("GET", "/sales/customer/selectCustomerJsonList", $("#searchForm").serialize(), function(result) {
	        
	        if(result != null && result.length == 1) {
	            var custInfo = result[0];
	        
	            console.log("성공.");
	            console.log("custId : " + result[0].custId);
	            console.log("userName1 : " + result[0].name);
	            
	            //
                $("#hiddenCustId").val(custInfo.custId); //Customer ID(Hidden)
                $("#custId").val(custInfo.custId); //Customer ID
	            $("#custTypeNm").val(custInfo.codeName1); //Customer Name
	            $("#typeId").val(custInfo.typeId); //Type
	            $("#name").val(custInfo.name); //Name
	            $("#nric").val(custInfo.nric); //NRIC/Company No
	            $("#nationNm").val(custInfo.name2); //Nationality
	            $("#raceId").val(custInfo.raceId); //Nationality
	            $("#race").val(custInfo.codeName2); //
	            $("#dob").val(custInfo.dob); //DOB
	            $("#gender").val(custInfo.gender); //Gender
	            $("#pasSportExpr").val(custInfo.pasSportExpr); //Passport Expiry
	            $("#visaExpr").val(custInfo.visaExpr); //Visa Expiry
                $("#email").val(custInfo.email); //Email
                $("#rem").val(custInfo.rem); //Remark
	            
	            if(custInfo.corpTypeId > 0) {
	                $("#corpTypeNm").val(custInfo.codeName); //Industry Code
	            }
	            else {
	            	$("#corpTypeNm").val(""); //Industry Code
	            }
                
                console.log("custInfo.custAddId :"+custInfo.custAddId);
                console.log("custInfo.custCntcId:"+custInfo.custCntcId);
                
	            if(custInfo.custAddId > 0) {
	                
	                //----------------------------------------------------------
                    // [Billing Detail] : Billing Address SETTING
	                //----------------------------------------------------------
	                $('#billAddrForm').clearForm();
	            	fn_loadMailAddr(custInfo.custAddId);

	                //----------------------------------------------------------
                    // [Installation] : Installation Address SETTING
	                //----------------------------------------------------------
	            	$('#instAddrForm').clearForm();
	            	fn_loadInstallAddr(custInfo.custAddId);
	            }
	            
	            if(custInfo.custCntcId > 0) {
	                //----------------------------------------------------------
                    // [Master Contact] : Owner & Purchaser Contact
                    //                    Additional Service Contact
	                //----------------------------------------------------------
	            	$('#custCntcForm').clearForm();	            	
                    //$('#liMstCntcNewAddr').addClass("blind");
    	            //$('#liMstCntcSelAddr').addClass("blind");
    	            //$('#liMstCntcNewAddr2').addClass("blind");
    	            //$('#liMstCntcSelAddr2').addClass("blind");
	            
	            	fn_loadCntcPerson(custInfo.custCntcId)
	            	fn_loadSrvCntcPerson(custInfo.custCareCntId);
	            	
	                //----------------------------------------------------------
                    // [Installation] : Installation Contact Person
	                //----------------------------------------------------------
	            	$('#instCntcForm').clearForm();
	            	fn_loadInstallationCntcPerson(custInfo.custCntcId);
	            }
	            
	            $('#liMstCntcNewAddr').removeClass("blind");
	            $('#liMstCntcSelAddr').removeClass("blind");
	            $('#liMstCntcNewAddr2').removeClass("blind");
	            $('#liMstCntcSelAddr2').removeClass("blind");
	            $('#liBillNewAddr').removeClass("blind");
	            $('#liBillSelAddr').removeClass("blind");
	            $('#liBillNewAddr2').removeClass("blind");
	            $('#liBillSelAddr2').removeClass("blind");
	            $('#liInstNewAddr').removeClass("blind");
	            $('#liInstSelAddr').removeClass("blind");
	            $('#liInstNewAddr2').removeClass("blind");
	            $('#liInstSelAddr2').removeClass("blind");
	            /*
                if (txtCustIndustry.Text == "Government")
                {
                    RadWindowManager1.RadAlert("<b>Goverment Customer</b>", 450, 160, "Alert", "callBackFn", null);
                }
                */
                
                if(custInfo.codeName == 'Government') {
                    Common.alert('<b>Goverment Customer</b>');
                }
	        }
	        else {
	            Common.alert('<b>Customer not found.<br>Your input customer ID :'+$("#searchCustId").val()+'</b>');
	        }
	    });
	}
	
	function fn_loadMailAddr(custAddId){
		console.log("fn_loadMailAddr START");
		
        $("#searchCustAddId").val(custAddId);
        
        Common.ajax("GET", "/sales/order/selectCustAddJsonInfo.do", $("#searchForm").serialize(), function(billCustInfo) {
            
            if(billCustInfo != null) {
            
                console.log("성공.");
                console.log("add1 : " + billCustInfo.add1);
                
                //
                //$("#hiddenCustAddId").val(billCustInfo.custAddId); //Customer Address ID(Hidden)
                $("#billAdd1").val(billCustInfo.add1); //Address
                $("#billAdd2").val(billCustInfo.add2); //Address
                $("#billAdd3").val(billCustInfo.add3); //Address
                $("#billPostCode").val(billCustInfo.postCode); //Post Code
                $("#billAreaName").val(billCustInfo.areaName); //Area
                $("#billStateName").val(billCustInfo.name1); //State
                $("#billCntyName").val(billCustInfo.name2); //Country
            }
        });
	}
	
    function fn_loadInstallAddr(custAddId){
        console.log("fn_loadInstallAddr START");
        
        $("#searchCustAddId").val(custAddId);
        
        Common.ajax("GET", "/sales/order/selectCustAddJsonInfo.do", $("#searchForm").serialize(), function(custInfo) {
            
            if(custInfo != null) {
            
                console.log("성공.");
                console.log("add1 : " + custInfo.add1);
                
                //
                $("#hiddenCustAddId").val(custInfo.custAddId); //Customer Address ID(Hidden)
                $("#add1").val(custInfo.add1); //Address
                $("#add2").val(custInfo.add2); //Address
                $("#add3").val(custInfo.add3); //Address
                $("#postCode").val(custInfo.postCode); //Post Code
                $("#areaName").val(custInfo.areaName); //Area
                $("#stateName").val(custInfo.name1); //State
                $("#cntyName").val(custInfo.name2); //Country
                $("#dscBrnchId").val(custInfo.brnchId); //DSC Branch
            }
        });
    }

    function fn_loadSrvCntcPerson(custCareCntId) {
        console.log("fn_loadSrvCntcPerson START");
        
        $("#searchCustCareCntId").val(custCareCntId);
        
        Common.ajax("GET", "/sales/order/selectSrvCntcJsonInfo.do", $("#searchForm").serialize(), function(srvCntcInfo) {
            
            if(srvCntcInfo != null) {
            
                console.log("성공.");
                console.log("srvCntcInfo:"+srvCntcInfo.custCareCntId);
                console.log("srvCntcInfo:"+srvCntcInfo.name);
                console.log("srvCntcInfo:"+srvCntcInfo.custInitial);
                console.log("srvCntcInfo:"+srvCntcInfo.email);
                
                //
                $("#srvCntcId").val(srvCntcInfo.custCareCntId);
                $("#srvCntcName").val(srvCntcInfo.name);
                $("#srvInitial").val(srvCntcInfo.custInitial);
                $("#srvCntcEmail").val(srvCntcInfo.email);
                $("#srvCntcTelM").val(srvCntcInfo.telM);
                $("#srvCntcTelR").val(srvCntcInfo.telR);
                $("#srvCntcTelO").val(srvCntcInfo.telO);
                $("#srvCntcTelF").val(srvCntcInfo.telf);
                $("#srvCntcExt").val(srvCntcInfo.ext);
            }
        });
    }
    
    function fn_loadCntcPerson(custCntcId){
        console.log("fn_loadCntcPerson START");
        
        $("#searchCustCntcId").val(custCntcId);
        
        Common.ajax("GET", "/sales/order/selectCustCntcJsonInfo.do", $("#searchForm").serialize(), function(custCntcInfo) {
            
            if(custCntcInfo != null) {
            
                console.log("성공.");
                console.log("srvCntcInfo:"+custCntcInfo.custCareCntId);
                console.log("srvCntcInfo:"+custCntcInfo.name);
                console.log("srvCntcInfo:"+custCntcInfo.custInitial);
                console.log("srvCntcInfo:"+custCntcInfo.email);
                
                //
                $("#custCntcId").val(custCntcInfo.custCnctId);
                $("#custCntcName").val(custCntcInfo.name);
                $("#custInitial").val(custCntcInfo.custInitial);
                $("#custCntcEmail").val(custCntcInfo.email);
                $("#custCntcTelM").val(custCntcInfo.telM1);
                $("#custCntcTelR").val(custCntcInfo.telR);
                $("#custCntcTelO").val(custCntcInfo.telO);
                $("#custCntcTelF").val(custCntcInfo.telf);
                $("#custCntcExt").val(custCntcInfo.ext);
            }
        });
    }

    function fn_loadInstallationCntcPerson(custCntcId){
        console.log("fn_loadInstallationCntcPerson START");
        
        $("#searchCustCntcId").val(custCntcId);
        
        Common.ajax("GET", "/sales/order/selectCustCntcJsonInfo.do", $("#searchForm").serialize(), function(instCntcInfo) {
            
            if(instCntcInfo != null) {
            
                console.log("성공.");

                $("#instCntcId").val(instCntcInfo.custCnctId);
                $("#instCntcName").val(instCntcInfo.name);
                $("#instInitial").val(instCntcInfo.custInitial);
                $("#instCntcEmail").val(instCntcInfo.email);
                $("#instCntcTelM").val(instCntcInfo.telM1);
                $("#instCntcTelR").val(instCntcInfo.telR);
                $("#instCntcTelO").val(instCntcInfo.telO);
                $("#instCntcTelF").val(instCntcInfo.telf);
                $("#instCntcExt").val(instCntcInfo.ext);
                $("#instGender").val(instCntcInfo.gender);
                $("#instNric").val(instCntcInfo.nric);
                $("#instDob").val(instCntcInfo.dob);
                $("#instRaceId").val(instCntcInfo.raceId);
                $("#instDept").val(instCntcInfo.dept);
                $("#instPost").val(instCntcInfo.pos);
            }
        });
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
	
	function fn_setBillGrp(grpOpt) {
	    
	    if(grpOpt == 'new') {
	    
    	    $('#sctBillMthd').removeClass("blind");
    	    $('#sctBillAddr').removeClass("blind");
    	    $('#sctBillPrefer').removeClass("blind");
    	    $('#sctBillSel').addClass("blind");
    	    
    	    $('#liBillNewAddr').removeClass("blind");
    	    $('#liBillSelAddr').removeClass("blind");
    	    $('#liBillPreferNewAddr').removeClass("blind");
    	    $('#liBillPreferNewAddr').removeClass("blind");
    	    
    	    $('#billMthdForm').clearForm();
    	    $('#billAddrForm').clearForm();
    	    $('#billPreferForm').clearForm();
    
    	    $('#billMthdEmailTxt1').val($('#custCntcEmail').val().trim());
    	    $('#billMthdEmailTxt2').val($('#srvCntcEmail').val().trim());
    
            $('#billRem').val("");
            $('#billRem').removeAttr("readonly");
    
    	    if($('#typeId').val() == '965') { //Company
    	        
    	        console.log("fn_setBillGrp 1 typeId : "+$('#typeId').val());
    
    	        $('#sctBillPrefer').removeClass("blind");
    
    	        fn_loadBillingPreference();
    	        
    	        /*
                btnBillGroupEStatement.Checked = true;
                btnBillGroupEmail_1.Checked = true;
                btnBillGroupEmail_1.Enabled = true;
                btnBillGroupEmail_2.Enabled = true;
                txtBillGroupEmail_1.Enabled = true;
                txtBillGroupEmail_2.Enabled = true;
                */
    
                $('#billMthdEstm').prop("checked", true);
                $('#billMthdEmail1').prop("checked", true).removeAttr("disabled");
                $('#billMthdEmail2').removeAttr("disabled");
    
    	    }
    	    else if($('#typeId').val() == '964') { //Individual
    	        
    	        console.log("fn_setBillGrp 2 typeId : "+$('#typeId').val());
                
                if(FormUtil.isNotEmpty($('#custCntcEmail').val().trim())) {
        	        /*
                    btnBillGroupEStatement.Checked = true;
                    btnBillGroupEmail_1.Checked = true;
                    btnBillGroupEmail_1.Enabled = true;
                    btnBillGroupEmail_2.Enabled = true;
                    txtBillGroupEmail_1.Enabled = true;
                    txtBillGroupEmail_2.Enabled = true;
                    */
                    $('#billMthdEstm').prop("checked", true);
                    $('#billMthdEmail1').prop("checked", true).removeAttr("disabled");
                    $('#billMthdEmail2').removeAttr("disabled");
                }
    
                $('#billMthdSms').prop("checked", true);
                $('#billMthdSms1').prop("checked", true).removeAttr("disabled");
                $('#billMthdSms2').removeAttr("disabled");
    	    }
    	}
    	else if(grpOpt == 'exist') {
    	    $('#sctBillMthd').addClass("blind");
    	    $('#sctBillAddr').addClass("blind");
    	    $('#sctBillPrefer').addClass("blind");
    	    $('#sctBillSel').removeClass("blind");
    	    
    	    $('#liBillNewAddr').removeClass("blind");
    	    $('#liBillSelAddr').removeClass("blind");
    	    $('#liBillPreferNewAddr').removeClass("blind");
    	    $('#liBillPreferNewAddr').removeClass("blind");
    	    
    	    $('#billMthdForm').clearForm();
    	    $('#billAddrForm').clearForm();
    	    $('#billPreferForm').clearForm();
    	    
    	    $('#billRem').val("");
    	    $('#billRem').prop("readonly", true);
    	}
	}
	
	function fn_loadBillingPreference() {
        $("#billPreferInitial").val($("#srvInitial").val().trim());
        $("#billPreferName").val($("#srvCntcName").val().trim());
        $("#billPreferTelO").val($("#srvCntcTelO").val().trim());
        $("#billPreferExt").val($("#srvCntcExt").val().trim());
	}

	$(function(){
	    $('#saveBtn').click(function() {
	        //$('#tabPC').addClass("blind");
	    });
	    $('#custBtn').click(function() {
	        $("#sUrl").val("/common/customerPop.do");
	        Common.searchpopupWin("searchForm", "/common/customerPop.do","");
	    });
	    $('[name="grpOpt"]').click(function() {
	        fn_setBillGrp($('input:radio[name="grpOpt"]:checked').val());
	    });
	    $('#billMthdSms').click(function() {
	        
            $('#billMthdSms1').prop("checked", false).prop("disabled", true);
            $('#billMthdSms2').prop("checked", false).prop("disabled", true);
	        
	        if($("#billMthdSms").is(":checked")) {
	            $('#billMthdSms1').removeAttr("disabled").prop("checked", true);
	            $('#billMthdSms2').removeAttr("disabled");
	        }
	    });
	    $('#billMthdEstm').click(function() {
	        
	        $('#spEmail1').text("");
	        $('#spEmail2').text("");
            $('#billMthdEmail1').prop("checked", false).prop("disabled", true);
            $('#billMthdEmail2').prop("checked", false).prop("disabled", true);
	        $('#billMthdEmailTxt1').val("").prop("disabled", true);
	        $('#billMthdEmailTxt2').val("").prop("disabled", true);
	        
	        if($("#billMthdEstm").is(":checked")) {
	            $('#spEmail1').text("*");
	            $('#spEmail2').text("*");
	            $('#billMthdEmail1').removeAttr("disabled").prop("checked", true);
	            $('#billMthdEmail2').removeAttr("disabled");
	            $('#billMthdEmailTxt1').removeAttr("disabled").val($('#custCntcEmail').val().trim());
	            $('#billMthdEmailTxt2').removeAttr("disabled").val($('#srvCntcEmail').val().trim());
	        }
	    });
        $('#custId').blur(function(event) {
            
            var strCustId = $('#custId').val();
            alert(strCustId);
            //CLEAR CUSTOMER 
//          this.ClearControl_Customer();
//          this.ClearControl_MailAddress();
//          this.ClearControl_ContactPerson();
            fn_clearCustomer();
            fn_clearMailAddress();
            fn_clearContactPerson();

            //CLEAR SALES
            fn_tabOnOffSet('PAY_CHA', 'HIDE');
            fn_tabOnOffSet('BIL_DTL', 'HIDE');
            
            $('#appType').val('');
            
            //ClearControl_Sales();
            fn_clearSales();

            //CLEAR RENTAL PAY SETTING
            $('#thrdParty').val('');
            
            fn_clearRentPay3thParty();
            fn_clearRentPaySetCRC();
            fn_clearRentPaySetDD();
            
            //CLEAR BILLING GROUP
            fn_clearBillGroup();

            //CLEAR INSTALLATION
            fn_clearInstallAddr();
            fn_clearCntcPerson();
            
            //CLEAR Search Form
            fn_clearSearchForm();
            
        	if(FormUtil.isNotEmpty(strCustId) && strCustId > 0) {
        	    
        	    fn_tabOnOffSet('BIL_DTL', 'SHOW');
        	    
        		fn_loadCustomer(strCustId);
        	}
        	else {
        	    Common.alert('<b>Invalid customer ID.</b>');
        	}
        });
        $('#appType').change(function() {
            
            fn_tabOnOffSet('PAY_CHA', 'HIDE');
            
            //Sales Order
            $('#salesOrderForm').clearForm();
            
            //CLEAR RENTAL PAY SETTING
            $('#thrdParty').val('');
            
            fn_clearRentPay3thParty();
            fn_clearRentPaySetCRC();
            fn_clearRentPaySetDD();

            //CLEAR BILLING GROUP
            fn_clearBillGroup();

            //ClearControl_Sales();
            fn_clearSales();
            
            //?FD문서에서 아래 항목 빠짐
            //this.btnAdvPayNo.Enabled = false;
            //this.btnAdvPayYes.Enabled = false;
        
	        var idx    = $("#appType option").index($("#appType option:selected"));
	        var selVal = $("#appType").val();
	        
	        if(idx > 0) {
                if(FormUtil.isEmpty($('#hiddenCustId').val())) {
                    $('#appType').val('');
                    Common.alert('<b>Please select customer first.</b>');
                    
                    var e = jQuery.Event("click");
                    $('#aCS').trigger(e);
                }
    	        else {
    	            switch(selVal) {
    	                case '66' : //RENTAL
    	                    fn_tabOnOffSet('PAY_CHA', 'SHOW');
                            //?FD문서에서 아래 항목 빠짐
                            //this.btnAdvPayNo.Enabled = true;
                            //this.btnAdvPayYes.Enabled = true;
                            
    	                    break;
    	                
    	                case '68' : //INSTALLMENT
                            $('#installDur').removeAttr("readonly");
                            
    	                    break;
                        
    	                case '1412' : //Outright Plus
                            $('#installDur').prop("readonly", true);
                            $('#installDur').val("36");
                            
                            //?FD문서에서 아래 항목 빠짐
                            //this.btnAdvPayNo.Enabled = false;
                            //this.btnAdvPayYes.Enabled = false;
                            
                            fn_tabOnOffSet('PAY_CHA', 'SHOW');
                            fn_tabOnOffSet('REL_CER', 'HIDE');
                            
    	                    break;
                        
                        default :
                            break;
    	            }
    	        }
	        }
	        
	    });
	});
	
	//tabNm : PAY_CHA, BIL_DTL, REL_CER
	//opt   : SHOW, HIDE
	function fn_tabOnOffSet(tabNm, opt) {
	    switch(tabNm) {
	        case 'PAY_CHA' :
	            if(opt == 'SHOW') {
        	        if($('#tabPC').hasClass("blind")) $('#tabPC').removeClass("blind");
        	        if($('#atcPC').hasClass("blind")) $('#atcPC').removeClass("blind");
                } else if(opt == 'HIDE') {
        	        if(!$('#tabPC').hasClass("blind")) $('#tabPC').addClass("blind");
        	        if(!$('#atcPC').hasClass("blind")) $('#atcPC').addClass("blind");
        	    }
        	    break;
	        case 'BIL_DTL' :
	            if(opt == 'SHOW') {
        	        if($('#tabBD').hasClass("blind")) $('#tabBD').removeClass("blind");
        	        if($('#atcBD').hasClass("blind")) $('#atcBD').removeClass("blind");
                } else if(opt == 'HIDE') {
        	        if(!$('#tabBD').hasClass("blind")) $('#tabBD').addClass("blind");
        	        if(!$('#atcBD').hasClass("blind")) $('#atcBD').addClass("blind");
        	    }
        	    break;
	        case 'REL_CER' :
	            if(opt == 'SHOW') {
        	        if($('#tabRC').hasClass("blind")) $('#tabRC').removeClass("blind");
        	        if($('#atcRC').hasClass("blind")) $('#atcRC').removeClass("blind");
                } else if(opt == 'HIDE') {
        	        if(!$('#tabRC').hasClass("blind")) $('#tabRC').addClass("blind");
        	        if(!$('#atcRC').hasClass("blind")) $('#atcRC').addClass("blind");
        	    }
        	    break;
            default :
                break;
        }
	}
	
	//ClearControl_Customer(Customer)
	function fn_clearCustomer() {
	    $('#custForm').clearForm();
	}
	
	//ClearControl_MailAddress(Billing Detail -> Billing Address)
	function fn_clearMailAddress() {
    	$('#liBillNewAddr').addClass("blind");
    	$('#liBillSelAddr').addClass("blind");
    	    
	    $('#billAddrForm').clearForm();
	}
	
	//ClearControl_ContactPerson(Billing Detail -> Billing Address)
	function fn_clearContactPerson() {
    	$('#liMstCntcNewAddr').addClass("blind");
    	$('#liMstCntcSelAddr').addClass("blind");
    	$('#liMstCntcNewAddr2').addClass("blind");
    	$('#liMstCntcSelAddr2').addClass("blind");
    	    
	    $('#ownerPurchsForm').clearForm();
	    $('#addSvcCntcForm').clearForm();
	}
	
	function fn_clearSales() {
	    $('#installDur').val('');
	    $('#ordProudct').val('');
	    $('#ordPromo').val('');
	    $('#relatedNo').val('');
	    $('#trialNoChk').prop("checked", false);
	    $('#trialNo').val('');
	    $('#ordPrice').val('');
	    $('#ordPriceId').val('');
	    $('#ordPv').val('');
	    $('#ordRentalFees').val('');
	}
	
	//ClearControl_RentPaySet_ThirdParty
	function fn_clearRentPay3thParty() {
	    $('#thrdPartyForm').clearForm();
	}
	
	//ClearControl_RentPaySet_DD
	function fn_clearRentPaySetDD() {
	    $('#ddForm').clearForm();
	}
	
	//ClearControl_RentPaySet_CRC
	function fn_clearRentPaySetCRC() {
	    $('#crcForm').clearForm();
	}
	
	//ClearControl_BillGroup
	function fn_clearBillGroup() {
	    
	    $('#sctBillMthd').addClass("blind");
	    $('#sctBillAddr').addClass("blind");
	    $('#sctBillPrefer').addClass("blind");
	    $('#sctBillSel').addClass("blind");
	    
	    $('#billMthdForm').clearForm();
	    $('#billAddrForm').clearForm();
	    $('#billPreferForm').clearForm();
	    $('#billSelForm').clearForm();
	}
	
	//ClearControl_Installation_Address
	function fn_clearInstallAddr() {
	    $('#liInstNewAddr').addClass("blind");
	    $('#liInstSelAddr').addClass("blind");

	    $('#instAddrForm').clearForm();
	}
	
	//ClearControl_Installation_ContactPerson
	function fn_clearCntcPerson() {
	    $('#liInstNewAddr2').addClass("blind");
	    $('#liInstSelAddr2').addClass("blind");

	    $('#instCntcForm').clearForm();
	}
	
	//ClearControl_Installation_ContactPerson
	function fn_clearSearchForm() {
	    $('#searchForm').clearForm();
	}
	
    function chgTab(tabNm) {
    	switch(tabNm) {
	        case 'doc' :
	            AUIGrid.resize(docGridID, 900, 380);
	            break;
            default :
                break;
        };
    }
</script>
</head>
<body>

<div id="popup_wrap" class="popup_wrap">
<!--div id="popup_wrap" class="popup_wrap pop_win"--><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>New Order</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1 num4">
    <li id="tabCS"><a id="aCS" href="#" class="on">Customer</a></li>
    <li id="tabMC"><a href="#">Master Contact</a></li>
    <li id="tabSO"><a href="#">Sales Order</a></li>
    <li id="tabPC"><a href="#">Payment Channel</a></li>
    <li id="tabBD"><a href="#">Billing Detail</a></li>
    <li id="tabIN"><a href="#">Installation</a></li>
    <li id="tabDC"><a href="#" onClick="javascript:chgTab('doc');">Documents</a></li>
    <li id="tabRC"><a href="#">Relief Certificate</a></li>
</ul>

<!--****************************************************************************
    Customer - Form ID(searchForm/custForm)
*****************************************************************************-->
<article class="tap_area"><!-- tap_area start -->
<section class="search_table"><!-- search_table start -->

<form id="searchForm" name="mainForm" action="#" method="post">
    <input id="sUrl"                name="sUrl"          type="hidden"/>
    <input id="searchCustId"        name="custId"        type="hidden"/>
    <input id="hiddenCustId"        name="custId"        type="hidden"/>
    <input id="searchCustAddId"     name="custAddId"     type="hidden"/>
    <input id="searchCustCntcId"    name="custCntcId"    type="hidden"/>
    <input id="searchCustCareCntId" name="custCareCntId" type="hidden"/>
    <input id="searchTypeCodeId"    name="typeCodeId"    type="hidden"/>
</form>
<form id="custForm" name="custForm" action="#" method="post">

<ul class="right_btns mb10">
    <li><p class="btn_grid"><a href="#">Add New Customer</a></p></li>
</ul>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Customer ID<span class="must">*</span></th>
    <td><input id="custId" name="custId" type="text" title="" placeholder="Customer ID" class="" /><a class="search_btn" id="custBtn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
    <th scope="row">Type</th>
    <td><input id="custTypeNm" name="custTypeNm" type="text" title="" placeholder="Customer Type" class="w100p" readonly/> 
        <input id="typeId" name="typeId" type="hidden"/>
    </td>
</tr>
<tr>
    <th scope="row">Name</th>
    <td><input id="name" name="name" type="text" title="" placeholder="Customer Name" class="w100p" readonly/></td>
    <th scope="row">NRIC/Company No</th>
    <td><input id="nric"" name="nric" type="text" title="" placeholder="NRIC/Company No" class="w100p" readonly/></td>
</tr>
<tr>
    <th scope="row">Nationality</th>
    <td><input id="nationNm" name="nationNm" type="text" title="" placeholder="Nationality" class="w100p" readonly/></td>
    <th scope="row">Race</th>
    <td><input id="raceId" name="raceId" type="text" title="" placeholder="Race" class="w100p" readonly/>
        <input id="race" name="race" type="hidden"/>
    </td>
</tr>
<tr>
    <th scope="row">DOB</th>
    <td><input id="dob" name="dob" type="text" title="" placeholder="DOB" class="w100p" readonly/></td>
    <th scope="row">Gender</th>
    <td><input id="gender" name="gender" type="text" title="" placeholder="Gender" class="w100p" readonly/></td>
</tr>
<tr>
    <th scope="row">Passport Expiry</th>
    <td><input id="pasSportExpr" name="pasSportExpr" type="text" title="" placeholder="Passport Expiry" class="w100p" readonly/></td>
    <th scope="row">Visa Expiry</th>
    <td><input id="visaExpr" name="visaExpr" type="text" title="" placeholder="Visa Expiry" class="w100p" readonly/></td>
</tr>
<tr>
    <th scope="row">Email</th>
    <td><input id="email" name="email" type="text" title="" placeholder="Email Address" class="w100p" readonly/></td>
    <th scope="row">Industry Code</th>
    <td><input id="corpTypeNm" name="corpTypeNm" type="text" title="" placeholder="Industry Code" class="w100p" readonly/></td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td colspan="3"><textarea  id="custRem" name="custRem" cols="20" rows="5" placeholder="Remark" readonly>xx</textarea></td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2"><a id="saveBtn" href="#">OK</a></p></li>
</ul>

</form>
</section><!-- search_table end -->

</article><!-- tap_area end -->

<!--****************************************************************************
    Master Contract
*****************************************************************************-->

<article class="tap_area"><!-- tap_area start -->

<aside class="title_line"><!-- title_line start -->
<h2>Owner &amp; Purchaser Contact</h2>
</aside><!-- title_line end -->

<ul class="right_btns mb10">
    <li id="liMstCntcNewAddr" class="blind"><p class="btn_grid"><a href="#">Add New Contact</a></p></li>
    <li id="liMstCntcSelAddr" class="blind"><p class="btn_grid"><a href="#">Select Another Contact</a></p></li>
</ul>

<!------------------------------------------------------------------------------
    Owner & Purchaser Contact - Form ID(ownerPurchsForm)
------------------------------------------------------------------------------->
<section class="search_table"><!-- search_table start -->

<form id=ownerPurchsForm name="ownerPurchsForm" action="#" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Initial</th>
    <td><input id="custInitial" name="custInitial" type="text" title="" placeholder="" class="w100p" /></td>
    <th scope="row">Name</th>
    <td><input id="custCntcName" name="custCntcName" type="text" title="" placeholder="" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">Tel(Mobile)(1)</th>
    <td><input id="custCntcTelM" name="custCntcTelM" type="text" title="" placeholder="" class="w100p" /></td>
    <th scope="row">Tel(Residence)(1)</th>
    <td><input id="custCntcTelR" name="custCntcTelR" type="text" title="" placeholder="" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">Tel(Office)(1)</th>
    <td><input id="custCntcTelO" name="custCntcTelO" type="text" title="" placeholder="" class="w100p" /></td>
    <th scope="row">Ext No.(1)</th>
    <td><input id="custCntcExt" name="custCntcExt" type="text" title="" placeholder="" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">Tel(Fax)(1)</th>
    <td><input id="custCntcTelF" name="custCntcTelF" type="text" title="" placeholder="" class="w100p" /></td>
    <th scope="row">Email(1)</th>
    <td><input id="custCntcEmail" name="custCntcEmail" type="text" title="" placeholder="" class="w100p" /></td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<!------------------------------------------------------------------------------
    Additional Service Contact - Form ID(addSvcCntcForm)
------------------------------------------------------------------------------->

<aside class="title_line"><!-- title_line start -->
<h2>Additional Service Contact</h2>
</aside><!-- title_line end -->

<ul class="right_btns mb10">
    <li id="liMstCntcNewAddr2" class="blind"><p class="btn_grid"><a href="#">Add New Contact</a></p></li>
    <li id="liMstCntcSelAddr2" class="blind"><p class="btn_grid"><a href="#">Select Another Contact</a></p></li>
</ul>

<section class="search_table"><!-- search_table start -->

<form id=addSvcCntcForm name="custCntcForm" action="#" method="post">
    <input id="srvCntcId" name="srvCntcId" type="hidden"/>
    <input id="srvInitial" name="srvInitial" type="hidden"/>
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Name</th>
    <td colspan="3"><input id="srvCntcName" name="srvCntcName" type="text" title="" placeholder="" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">Tel(Mobile)(2)</th>
    <td><input id="srvCntcTelM" name="srvCntcTelM" type="text" title="" placeholder="" class="w100p" /></td>
    <th scope="row">Tel(Residence)(2)</th>
    <td><input id="srvCntcTelR" name="srvCntcTelR" type="text" title="" placeholder="" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">Tel(Office)(2)</th>
    <td><input id="srvCntcTelO" name="srvCntcTelO" type="text" title="" placeholder="" class="w100p" /></td>
    <th scope="row">Ext No.(2)</th>
    <td><input id="srvCntcExt" name="srvCntcExt" type="text" title="" placeholder="" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">Tel(Fax)(2)</th>
    <td><input id="srvCntcTelF" name="srvCntcTelF" type="text" title="" placeholder="" class="w100p" /></td>
    <th scope="row">Email(2)</th>
    <td><input id="srvCntcEmail" name="srvCntcEmail" type="text" title="" placeholder="" class="w100p" /></td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2"><a href="#">OK</a></p></li>
</ul>

</form>
</section><!-- search_table end -->

</article><!-- tap_area end -->

<!--****************************************************************************
    Sales Order
*****************************************************************************-->
<article class="tap_area"><!-- tap_area start -->

<section class="search_table"><!-- search_table start -->

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
    <th scope="row">Application Type<span class="must">*</span></th>
    <td>
    <select id="appType" name="appType" class="w100p"></select>
    </td>
    <th scope="row">Order Date<span class="must">*</span></th>
    <td><span>31/07/2017</span></td>
</tr>
<tr>
    <th scope="row">Installment Duration<span class="must">*</span></th>
    <td><input id="installDur" name="installDur" type="text" title="" placeholder="" class="w100p" readonly/></td>
    <th scope="row">Salesman Code<span class="must">*</span></th>
    <td><input type="text" title="" placeholder="" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">Reference No<span class="must">*</span></th>
    <td><input type="text" title="" placeholder="" class="w100p" /></td>
    <th scope="row">Salesman Type</th>
    <td><input type="text" title="" placeholder="" class="" /><a href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
</tr>
<tr>
    <th scope="row">PO No<span class="must">*</span></th>
    <td><input type="text" title="" placeholder="" class="w100p" /></td>
    <th scope="row">Salesman Name</th>
    <td><input type="text" title="" placeholder="" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">Product<span class="must">*</span></th>
    <td><input id="ordProudct" name="ordProudct" type="text" title="" placeholder="" class="" /><a href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
    <th scope="row">Salesman NRIC</th>
    <td><input type="text" title="" placeholder="" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">Campaign<span class="must">*</span></th>
    <td>
    <select class="w100p">
        <option value="">11</option>
        <option value="">22</option>
        <option value="">33</option>
    </select>
    </td>
    <th scope="row">Department Code</th>
    <td><input type="text" title="" placeholder="" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">Promotion<span class="must">*</span></th>
    <td>
    <select id="ordPromo" name="ordPromo" class="w100p"></select>
    </td>
    <th scope="row">Group Code</th>
    <td><input type="text" title="" placeholder="" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">Price/RPF (RM)</th>
    <td><input id="ordPrice" name="ordPrice" type="text" title="" placeholder="" class="w100p" />
        <input id="ordPriceId" name="ordPriceId" type="text" /></td>
    <th scope="row">Organization Code</th>
    <td><input type="text" title="" placeholder="" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">Rental Fees (RM)</th>
    <td><input id="ordRentalFees" name="ordRentalFees" type="text" title="" placeholder="" class="w100p" /></td>
    <th scope="row">Trial No </th>
    <td><label><input id="trialNoChk" name="trialNoChk" type="checkbox" /><span></span></label>
               <input id="trialNo" name="trialNo" type="text" title="" placeholder="" class="readonly" readonly="readonly" /></td>
</tr>
<tr>
    <th scope="row">PV</th>
    <td><input id="ordPv" name="ordPv" type="text" title="" placeholder="" class="w100p" /></td>
    <th scope="row">Related No</th>
    <td><input id="relatedNo" name="relatedNo" type="text" title="" placeholder="" class="readonly" readonly="readonly" /></td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2"><a href="#">OK</a></p></li>
</ul>

</form>
</section><!-- search_table end -->

</article><!-- tap_area end -->

<!--****************************************************************************
    Payment Channel - Form ID(payChnnlForm)
*****************************************************************************-->
<article id="atcPC" class="tap_area"><!-- tap_area start -->

<section class="search_table"><!-- search_table start -->

<table class="type1 mb1m"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Pay By Third Party</th>
    <td colspan="3">
    <label><input id="thrdParty" name="thrdParty" type="checkbox" /><span></span></label>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Third Party</h2>
</aside><!-- title_line end -->

<ul class="right_btns mb10">
    <li><p class="btn_grid"><a href="#">Add New Third Party</a></p></li>
</ul>

<!------------------------------------------------------------------------------
    Third Party - Form ID(thrdPartyForm)
------------------------------------------------------------------------------->
<form id="thrdPartyForm" name="thrdPartyForm" action="#" method="post">
<table class="type1 mb1m"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:170px" />
    <col style="width:*" />
    <col style="width:190px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Customer ID<span class="must">*</span></th>
    <td><input id="thrdPartyId" name="thrdPartyId" type="text" title="" placeholder="" class="" /><a href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
    <th scope="row">Type</th>
    <td><input id="thrdPartyType" name="thrdPartyType" type="text" title="" placeholder="Costomer Type" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">Name</th>
    <td><input id="thrdPartyName" name="thrdPartyName" type="text" title="" placeholder="Customer Name" class="w100p" /></td>
    <th scope="row">NRIC/Company No</th>
    <td><input id="thrdPartyNrid" name="thrdPartyNrid" type="text" title="" placeholder="NRIC/Company Number" class="w100p" /></td>
</tr>
</tbody>
</table><!-- table end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:170px" />
    <col style="width:*" />
    <col style="width:190px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Rental Paymode<span class="must">*</span></th>
    <td>
    <select id="rentPayMode" name="rentPayMode" class="w100p"></select>
    </td>
    <th scope="row">NRIC on DD/Passbook</th>
    <td><input id="rentPayIC" name="rentPayIC" type="text" title="" placeholder="NRIC on DD/Passbook" class="w100p" /></td>
</tr>
</tbody>
</table><!-- table end -->
</form>

<aside class="title_line"><!-- title_line start -->
<h2>Credit Card</h2>
</aside><!-- title_line end -->

<ul class="right_btns mb10">
    <li><p class="btn_grid"><a href="#">Add New Credit Card</a></p></li>
    <li><p class="btn_grid"><a href="#">Select Another Credit Card</a></p></li>
</ul>
<!------------------------------------------------------------------------------
    Credit Card - Form ID(crcForm)
------------------------------------------------------------------------------->
<form id="crcForm" name="crcForm" action="#" method="post">

<table class="type1 mb1m"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:170px" />
    <col style="width:*" />
    <col style="width:190px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Credit Card Number<span class="must">*</span></th>
    <td><input id="rentPayCRCNo" name="rentPayCRCNo" type="text" title="" placeholder="Credit Card Number" class="w100p" /></td>
    <th scope="row">Credit Card Type</th>
    <td><input id="rentPayCRCType" name="rentPayCRCType" type="text" title="" placeholder="Credit Card Type" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">Name On Card</th>
    <td><input id="rentPayCRCName" name="rentPayCRCName" type="text" title="" placeholder="Name On Card" class="w100p" /></td>
    <th scope="row">Expiry</th>
    <td><input id="rentPayCRCExpiry" name="rentPayCRCExpiry" type="text" title="" placeholder="Expiry" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">Issue Bank</th>
    <td><input id="rentPayCRCBank" name="rentPayCRCBank" type="text" title="" placeholder="Issue Bank" class="w100p" />
        <input id="rentPayCRCBankId" name="rentPayCRCBankId" type="text" title="" class="w100p" /></td>
    <th scope="row">Card Type</th>
    <td><input type="text" title="" placeholder="Card Type" class="w100p" /></td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2"><a href="#">OK</a></p></li>
</ul>
</form>

<aside class="title_line"><!-- title_line start -->
<h2>Direct Debit</h2>
</aside><!-- title_line end -->

<ul class="right_btns mb10">
    <li><p class="btn_grid"><a href="#">Add New Credit Card</a></p></li>
    <li><p class="btn_grid"><a href="#">Select Another Credit Card</a></p></li>
</ul>
<!------------------------------------------------------------------------------
    Direct Debit - Form ID(ddForm)
------------------------------------------------------------------------------->
<form id="ddForm" name="ddForm" action="#" method="post">

<table class="type1 mb1m"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:170px" />
    <col style="width:*" />
    <col style="width:190px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Account Number<span class="must">*</span></th>
    <td><input id="accNo" name="accNo" type="text" title="" placeholder="Account Number" class="w100p" /></td>
    <th scope="row">Account Type</th>
    <td><input id="accType" name="accType" type="text" title="" placeholder="Account Type" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">Account Holder</th>
    <td><input id="accName" name="accName" type="text" title="" placeholder="Account Holder" class="w100p" /></td>
    <th scope="row">Issue Bank Branch</th>
    <td><input id="accBranch" name="accBranch" type="text" title="" placeholder="Issue Bank Branch" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">Issue Bank</th>
    <td colspan=3><input id="accBank" name="accBank" type="text" title="" placeholder="Issue Bank" class="w100p" />
        <input id="accBankId" name="accBankId" type="text" title="" class="w100p" /></td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2"><a href="#">OK</a></p></li>
</ul>
</form>

</section><!-- search_table end -->

</article><!-- tap_area end -->

<!--****************************************************************************
    Billing Detail
*****************************************************************************-->
<article id="atcBD" class="tap_area"><!-- tap_area start -->

<section class="search_table"><!-- search_table start -->

<!-- New Billing Group Type start -->
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Group Option<span class="must">*</span></th>
    <td>
    <label><input type="radio" name="grpOpt" value="new"  /><span>New Billing Group</span></label>
    <label><input type="radio" name="grpOpt" value="exist"/><span>Existion Billing Group</span></label>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<!------------------------------------------------------------------------------
    Billing Method - Form ID(billMthdForm)
------------------------------------------------------------------------------->
<section id="sctBillMthd" class="blind">

<form id="billMthdForm" name="billMthdForm" action="#" method="post">
        
<table class="type1 mb1m"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row" rowspan="5">Billing Method<span class="must">*</span></th>
    <td colspan="3">
    <label><input type="checkbox" /><span>Post</span></label>
    </td>
</tr>
<tr>
    <td colspan="3">
    <label><input id="billMthdSms" name="billMthdSms" type="checkbox" /><span>SMS</span></label>
    <label><input id="billMthdSms1" name="billMthdSms1" type="checkbox" disabled/><span>Mobile 1</span></label>
    <label><input id="billMthdSms2" name="billMthdSms2" type="checkbox" disabled/><span>Mobile 2</span></label>
    </td>
</tr>
<tr>
    <td>
    <label><input id="billMthdEstm" name="billMthdEstm" type="checkbox" /><span>E-Billing</span></label>
    <label><input id="billMthdEmail1" name="billMthdEmail1" type="checkbox" disabled/><span>Email 1</span></label>
    <label><input id="billMthdEmail2" name="billMthdEmail2" type="checkbox" disabled/><span>Email 2</span></label>
    </td>
    <th scope="row">Email(1)<span id="spEmail1" class="must">*</span></th>
    <td><input id="billMthdEmailTxt1" name="billMthdEmailTxt1" type="text" title="" placeholder="Email Address" class="w100p" disabled/></td>
</tr>
<tr>
    <td></td>
    <th scope="row">Email(2)<span id="spEmail2" class="must">*</span></th>
    <td><input id="billMthdEmailTxt2" name="billMthdEmailTxt2" type="text" title="" placeholder="Email Address" class="w100p" disabled/></td>
</tr>
<tr>
    <td>
    <label><input type="checkbox" /><span>Web Portal</span></label>
    </td>
    <th scope="row">Web address(URL)</th>
    <td><input type="text" title="" placeholder="Web Address" class="w100p" /></td>
</tr>
</tbody>
</table><!-- table end -->
</form>
</section>

<!------------------------------------------------------------------------------
    Billing Address - Form ID(billAddrForm)
------------------------------------------------------------------------------->
<section id="sctBillAddr" class="blind">
<form id="billAddrForm" name="billAddrForm" action="#" method="post">
    <input id="hiddenBillPostCode"  name="hiddenBillPostCode"  type="hidden"/>
    <input id="hiddenBillAreaName"  name="hiddenBillAreaName"  type="hidden"/>
    <input id="hiddenBillStateName" name="hiddenBillStateName" type="hidden"/>
    
<aside class="title_line"><!-- title_line start -->
<h2>Billing Address</h2>
</aside><!-- title_line end -->

<ul class="right_btns mb10">
    <li id="liBillNewAddr" class="blind"><p class="btn_grid"><a href="#">Add New Address</a></p></li>
    <li id="liBillSelAddr" class="blind"><p class="btn_grid"><a href="#">Select Another Address</a></p></li>
</ul>

<table class="type1 mb1m"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row" rowspan="3">Address<span class="must">*</span></th>
    <td colspan="3"><input id="billAdd1" name="billAdd1" type="text" title="" placeholder="Address (1)" class="w100p" readonly/></td>
</tr>
<tr>
    <td colspan="3"><input id="billAdd2" name="billAdd2" type="text" title="" placeholder="Address (2)" class="w100p" readonly/></td>
</tr>
<tr>
    <td colspan="3"><input id="billAdd3" name="billAdd3" type="text" title="" placeholder="Address (3)" class="w100p" readonly/></td>
</tr>
<tr>
    <th scope="row">Postcode</th>
    <td><input id="billPostCode" name="billPostCode" type="text" title="" placeholder="Postcode" class="w100p" readonly/></td>
    <th scope="row">Area</th>
    <td><input id="billAreaName" name="billAreaName" type="text" title="" placeholder="Area" class="w100p" readonly/></td>
</tr>
<tr>
    <th scope="row">State</th>
    <td><input id="billStateName" name="billStateName" type="text" title="" placeholder="State" class="w100p" readonly/></td>
    <th scope="row">Country</th>
    <td><input id="billCntyName" name="billCntyName" type="text" title="" placeholder="Country" class="w100p" readonly/></td>
</tr>
</tbody>
</table><!-- table end -->
<!-- Existing Type end -->
</form>
</section>
<br>

<section id="sctBillPrefer" class="blind">
<aside class="title_line"><!-- title_line start -->
<h2>Billing Preference</h2>
</aside><!-- title_line end -->

<ul class="right_btns mb10">
    <li id="liBillPreferNewAddr" class="blind"><p class="btn_grid"><a href="#">Add New Contact</a></p></li>
    <li id="liBillPreferSelAddr" class="blind"><p class="btn_grid"><a href="#">Select Another Contact</a></p></li>
</ul>

<!------------------------------------------------------------------------------
    Billing Preference - Form ID(billPreferForm)
------------------------------------------------------------------------------->
<section class="search_table"><!-- search_table start -->
<form id=billPreferForm name="billPreferForm" action="#" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Initials<span class="must">*</span></th>
    <td colspan="3"><input id="billPreferInitial" name="billPreferInitial" type="text" title="" placeholder="Initial" class="w100p" readonly/></td>
</tr>
<tr>
    <th scope="row">Name<span class="must">*</span></th>
    <td colspan="3"><input id="billPreferName" name="billPreferName" type="text" title="" placeholder="Name" class="w100p" readonly/></td>
</tr>
<tr>
    <th scope="row">Tel(Office)<span class="must">*</span></th>
    <td><input id="billPreferTelO" name="billPreferTelO" type="text" title="" placeholder="Tel(Office)" class="w100p" readonly/></td>
    <th scope="row">Ext No.<span class="must">*</span></th>
    <td><input id="billPreferExt" name="billPreferExt" type="text" title="" placeholder="Ext No." class="w100p" readonly/></td>
</tr>
</tbody>
</table><!-- table end -->

</section><!-- search_table end -->
</section>

<!------------------------------------------------------------------------------
    Billing Group Selection - Form ID(billPreferForm)
------------------------------------------------------------------------------->
<section id="sctBillSel" class="blind">
<form id=billSelForm name="billSelForm" action="#" method="post">
    
<aside class="title_line"><!-- title_line start -->
<h2>Billing Group Selection</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Billing Group<span class="must">*</span></th>
    <td><input type="text" title="" placeholder="" class="" /><a href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></td>
    <th scope="row">Billing Type<span class="must">*</span></th>
    <td><input type="text" title="" placeholder="" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">Billing Address</th>
    <td colspan="3"><textarea cols="20" rows="5"></textarea></td>
</tr>
</tbody>
</table><!-- table end -->
</form>
</section>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Remark</th>
    <td><textarea id="billRem" name="billRem" cols="20" rows="5"></textarea></td>
</tr>
</tbody>
</table><!-- table end -->
<!-- Existing Type end -->

<ul class="center_btns">
    <li><p class="btn_blue2"><a href="#">OK</a></p></li>
</ul>

</form>
</section><!-- search_table end -->

</article><!-- tap_area end -->

<!--****************************************************************************
    Installation
*****************************************************************************-->
<article class="tap_area"><!-- tap_area start -->

<section class="search_table"><!-- search_table start -->
 
<aside class="title_line"><!-- title_line start -->
<h2>Installation Address</h2>
</aside><!-- title_line end -->

<ul class="right_btns mb10">
    <li id="liInstNewAddr" class="blind"><p class="btn_grid"><a href="#">Add New Address</a></p></li>
    <li id="liInstSelAddr" class="blind"><p class="btn_grid"><a href="#">Select Another Address</a></p></li>
</ul>

<!------------------------------------------------------------------------------
    Installation Address - Form ID(instAddrForm)
------------------------------------------------------------------------------->
<form id="instAddrForm" name="instAddrForm" action="#" method="post">
    <input id="hiddenCustAddId" name="custAddId" type="hidden"/>
    <input id="instCntcId"    name="instCntcId"    type="hidden"/>
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:120px" />
    <col style="width:*" />
    <col style="width:120px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row" rowspan="3">Address<span class="must">*</span></th>
    <td colspan="3"><input id="add1" name="add1" type="text" title="" placeholder="" class="w100p" readonly/></td>
</tr>
<tr>
    <td colspan="3"><input id="add2" name="add2" type="text" title="" placeholder="" class="w100p" readonly/></td>
</tr>
<tr>
    <td colspan="3"><input id="add3" name="add3" type="text" title="" placeholder="" class="w100p" readonly/></td>
</tr>
<tr>
    <th scope="row">Postcode</th>
    <td><input id="postCode" name="postCode" type="text" title="" placeholder="" class="w100p" readonly/></td>
    <th scope="row">Area</th>
    <td><input id="areaName" name="areaName" type="text" title="" placeholder="" class="w100p" readonly/></td>
</tr>
<tr>
    <th scope="row">State</th>
    <td><input id="stateName" name="stateName" type="text" title="" placeholder="" class="w100p" readonly/></td>
    <th scope="row">Country</th>
    <td><input id="cntyName" name="cntyName" type="text" title="" placeholder="" class="w100p" readonly/></td>
</tr>
</tbody>
</table><!-- table end -->
</form>

<section id="tbInstCntcPerson" class="blind">
    
<aside class="title_line"><!-- title_line start -->
<h2>Installation Contact Person</h2>
</aside><!-- title_line end -->

<ul class="right_btns mb10">
    <li id="liInstNewAddr2" class="blind"><p class="btn_grid"><a href="#">Add New Address</a></p></li>
    <li id="liInstSelAddr2" class="blind"><p class="btn_grid"><a href="#">Select Another Address</a></p></li>
</ul>

<!------------------------------------------------------------------------------
    Installation Contact Person - Form ID(instCntcForm)
------------------------------------------------------------------------------->
<form id="instCntcForm" name="instCntcForm" action="#" method="post">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Name<span class="must">*</span></th>
    <td><input id="instCntcName" name="instCntcName" type="text" title="" placeholder="" class="w100p" readonly/></td>
    <th scope="row">Initial</th>
    <td><input id="instInitial" name="instInitial" type="text" title="" placeholder="" class="w100p" readonly/></td>
    <th scope="row">Gender</th>
    <td><input id="instGender" name="instGender" type="text" title="" placeholder="" class="w100p" readonly/></td>
</tr>
<tr>
    <th scope="row">NRIC</th>
    <td><input id="instNric" name="instNric" type="text" title="" placeholder="" class="w100p" readonly/></td>
    <th scope="row">DOB</th>
    <td><input id="instDob" name="instDob" type="text" title="" placeholder="" class="w100p" readonly/></td>
    <th scope="row">Race</th>
    <td><input id="instRaceId" name="instRaceId" type="text" title="" placeholder="" class="w100p" readonly/></td>
</tr>
<tr>
    <th scope="row">Email</th>
    <td><input id="instCntcEmail" name="instCntcEmail" type="text" title="" placeholder="" class="w100p" readonly/></td>
    <th scope="row">Department</th>
    <td><input id="instDept" name="instDept" type="text" title="" placeholder="" class="w100p" readonly/></td>
    <th scope="row">Post</th>
    <td><input id="instPost" name="instPost" type="text" title="" placeholder="" class="w100p" readonly/></td>
</tr>
<tr>
    <th scope="row">Tel(Mobile)</th>
    <td><input id="instCntcTelM" name="instCntcTelM" type="text" title="" placeholder="" class="w100p" readonly/></td>
    <th scope="row">Tel(Residence)</th>
    <td><input id="instCntcTelR" name="instCntcTelR" type="text" title="" placeholder="" class="w100p" readonly/></td>
    <th scope="row">Tel(Office)</th>
    <td><input id="instCntcTelO" name="instCntcTelO" type="text" title="" placeholder="" class="w100p" readonly/></td>
</tr>
<tr>
    <th scope="row">Tel(Fax)</th>
    <td><input id="instCntcTelF" name="instCntcTelF" type="text" title="" placeholder="" class="w100p" readonly/></td>
    <th scope="row"></th>
    <td></td>
    <th scope="row"></th>
    <td></td>
</tr>
</tbody>
</table><!-- table end -->
</form>
</section>

<aside class="title_line"><!-- title_line start -->
<h2>Installation Information</h2>
</aside><!-- title_line end -->

<!------------------------------------------------------------------------------
    Installation Contact Person - Form ID(installForm)
------------------------------------------------------------------------------->
<form id="installForm" name="installForm" action="#" method="post">

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
    <th scope="row">DSC Branch<span class="must">*</span></th>
    <td colspan="3">
    <select id="dscBrnchId" name="dscBrnchId" class="w100p"></select>
    </td>
</tr>
<tr>
    <th scope="row">Prefer Install Date<span class="must">*</span></th>
    <td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" /></td>
    <th scope="row">Prefer Install Time<span class="must">*</span></th>
    <td>
    <div class="time_picker"><!-- time_picker start -->
    <input type="text" title="" placeholder="" class="time_date w100p" />
    <ul>
        <li>Time Picker</li>
        <li><a href="#">12:00 AM</a></li>
        <li><a href="#">01:00 AM</a></li>
        <li><a href="#">02:00 AM</a></li>
        <li><a href="#">03:00 AM</a></li>
        <li><a href="#">04:00 AM</a></li>
        <li><a href="#">05:00 AM</a></li>
        <li><a href="#">06:00 AM</a></li>
        <li><a href="#">07:00 AM</a></li>
        <li><a href="#">08:00 AM</a></li>
        <li><a href="#">09:00 AM</a></li>
        <li><a href="#">10:00 AM</a></li>
        <li><a href="#">11:00 AM</a></li>
        <li><a href="#">12:00 PM</a></li>
        <li><a href="#">01:00 PM</a></li>
        <li><a href="#">02:00 PM</a></li>
        <li><a href="#">03:00 PM</a></li>
        <li><a href="#">04:00 PM</a></li>
        <li><a href="#">05:00 PM</a></li>
        <li><a href="#">06:00 PM</a></li>
        <li><a href="#">07:00 PM</a></li>
        <li><a href="#">08:00 PM</a></li>
        <li><a href="#">09:00 PM</a></li>
        <li><a href="#">10:00 PM</a></li>
        <li><a href="#">11:00 PM</a></li>
    </ul>
    </div><!-- time_picker end -->
    </td>
</tr>
<tr>
    <th scope="row">Special Instruction<span class="must">*</span></th>
    <td colspan="3"><textarea cols="20" rows="5"></textarea></td>
</tr>
</tbody>
</table><!-- table end -->
</form>
<!-- Existing Type end -->

<ul class="center_btns">
    <li><p class="btn_blue2"><a href="#">OK</a></p></li>
</ul>

</form>
</section><!-- search_table end -->

</article><!-- tap_area end -->

<!--****************************************************************************
    Documents
*****************************************************************************-->
<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_doc_wrap" style="width:100%; height:380px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<!--****************************************************************************
    Relief Certificate - Form ID(rliefForm)
*****************************************************************************-->
<article id="atcRC" class="tap_area"><!-- tap_area start -->

<section class="search_table"><!-- search_table start -->
<form id="rliefForm" name="rliefForm" action="#" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:200px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Reference No<span class="must">*</span></th>
    <td><input type="text" title="" placeholder="Cert Reference No" class="w100p" /></td>
    <th scope="row">Certificate Date<span class="must">*</span></th>
    <td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" /></td>
</tr>
<tr>
    <th scope="row">GST Registration No</th>
    <td colspan="3"><input type="text" title="" placeholder="" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td colspan="3"><textarea cols="20" rows="5"></textarea></td>
</tr>
<tr>
    <th scope="row">Upload Relief Cert(.zip)</th>
    <td colspan="3">
    <div class="auto_file"><!-- auto_file start -->
    <input type="file" title="file add" />
    </td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

</article><!-- tap_area end -->

</section><!-- tap_wrap end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
</body>
</html>