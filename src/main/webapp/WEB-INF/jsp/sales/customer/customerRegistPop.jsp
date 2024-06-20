<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">

    //AUIGrid 그리드 객체
    var myGridID;          // credit card
    var myGridID1;        // bank account grid

    //Choose Message
    var optionState = {chooseMessage: " 1.States "};
    var optionCity = {chooseMessage: "2. City"};
    var optionPostCode = {chooseMessage: "3. Post Code"};
    var optionArea = {chooseMessage: "4. Area"};

    // 등록창
    var addBankDialog;

    // popup 크기
    var option = {
            winName : "popup",
            width : "1200px",   // 창 가로 크기
            height : "400px",    // 창 세로 크기
            resizable : "yes", // 창 사이즈 변경. (yes/no)(default : yes)
            scrollbars : "no" // 스크롤바. (yes/no)(default : yes)
    };

    $(document).ready(function(){
    	console.log("customerRegistPop");
         //j_date
        var pickerOpts={
                changeMonth:true,
                changeYear:true,
                dateFormat: "dd/mm/yy"
        };

        $(".j_date").datepicker(pickerOpts);

        var monthOptions = {
            pattern: 'mm/yyyy',
            selectedYear: 2017,
            startYear: 2007,
            finalYear: 2027
        };

        $(".j_date2").monthpicker(monthOptions);

        // AUIGrid 그리드를 생성합니다.
        createAUIGrid();

  //      AUIGrid.setSelectionMode(myGridID, "singleRow");

        // 셀 더블클릭 이벤트 바인딩

        // 셀 클릭 이벤트 바인딩

        //Magic Address
        fn_initAddress(); //init
        CommonCombo.make('_mState_', "/sales/customer/selectMagicAddressComboList", '' , '', optionState);
         //f_multiCombo 함수 호출이 되어야만 multi combo 화면이 안깨짐.
        doGetCombo('/common/selectCodeList.do', '8', '','_cmbTypeId_', 'S' , '');                              // Customer Type Combo Box
        doGetCombo('/sales/customer/getNationList', '338' , '' ,'_cmbNation_' , 'S');        // Nationality Combo Box
        doGetCombo('/common/selectCodeList.do', '95', '','_cmbCorpTypeId_', 'S' , '');                      // Company Type Combo Box
        doGetCombo('/common/selectCodeList.do', '17', '','_cmbInitials_', 'S' , '');                             // Initials Combo Box
        doGetCombo('/common/selectCodeList.do', '2', '','_cmbRace_', 'S' , '');                                 // Race Combo Box
    //    doGetCombo('/common/selectCodeList.do', '20', '','cmbBankType', 'S' , '');                         // Add Bank Type Combo Box
       // getAddrRelay('mstate' , '1' , 'state', '');

        //Enter Event
        $('#_searchSt_').keydown(function (event) {
            if (event.which === 13) {    //enter
                fn_addrSearch();
            }
        });

        $("#_nric_").keyup(function(){$(this).val($.trim($(this).val().toUpperCase()));});
    });

    function fn_initAddress(){

           $('#_mCity_').append($('<option>', { value: '', text: '2. City' }));
           $('#_mCity_').val('');
           $("#_mCity_").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});

           $('#_mPostCd_').append($('<option>', { value: '', text: '3. Post Code' }));
           $('#_mPostCd_').val('');
           $("#_mPostCd_").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});

           $('#_mArea_').append($('<option>', { value: '', text: '4. Area' }));
           $('#_mArea_').val('');
           $("#_mArea_").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});

    }

    /*####### Magic Address #########*/
    function fn_selectState(selVal){

        var tempVal = selVal;

        if('' == selVal || null == selVal){
            //전체 초기화
            fn_initAddress();

        }else{

            $("#_mCity_").attr({"disabled" : false  , "class" : "w100p"});

            $('#_mPostCd_').append($('<option>', { value: '', text: '3. Post Code' }));
            $('#_mPostCd_').val('');
            $("#_mPostCd_").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});

            $('#_mArea_').append($('<option>', { value: '', text: '4. Area' }));
            $('#_mArea_').val('');
            $("#_mArea_").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});

            //Call ajax
            var cityJson = {state : tempVal}; //Condition
            CommonCombo.make('_mCity_', "/sales/customer/selectMagicAddressComboList", cityJson, '' , optionCity);
        }

    }

    function fn_selectCity(selVal){

        var tempVal = selVal;

        if('' == selVal || null == selVal){

             $('#_mPostCd_').append($('<option>', { value: '', text: '3. Post Code' }));
             $('#_mPostCd_').val('');
             $("#_mPostCd_").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});

             $('#_mArea_').append($('<option>', { value: '', text: '4. Area' }));
             $('#_mArea_').val('');
             $("#_mArea_").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});

             $('#_searchSt_').val('');
             $("#_searchSt_").attr("disabled","disabled");

        }else{

            $("#_mPostCd_").attr({"disabled" : false  , "class" : "w100p"});

            $('#_mArea_').append($('<option>', { value: '', text: '4. Area' }));
            $('#_mArea_').val('');
            $("#_mArea_").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});

            //Call ajax
            var postCodeJson = {state : $("#_mState_").val() , city : tempVal}; //Condition
            CommonCombo.make('_mPostCd_', "/sales/customer/selectMagicAddressComboList", postCodeJson, '' , optionPostCode);

            $("#_searchSt_").attr("disabled",false);
        }

    }


    function fn_selectPostCode(selVal){

        var tempVal = selVal;

        if('' == selVal || null == selVal){

            $('#_mArea_').append($('<option>', { value: '', text: '4. Area' }));
            $('#_mArea_').val('');
            $("#_mArea_").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});

        }else{

            $("#_mArea_").attr({"disabled" : false  , "class" : "w100p"});

            //Call ajax
            var areaJson = {state : $("#_mState_").val(), city : $("#_mCity_").val() , postcode : tempVal}; //Condition
            CommonCombo.make('_mArea_', "/sales/customer/selectMagicAddressComboList", areaJson, '' , optionArea);
        }

    }


    /*####### Magic Address #########*/
    function createAUIGrid() {
        // AUIGrid 칼럼 설정
        // credit card
        var columnLayout = [
            {
                dataField : "cardType",
                headerText : '<spring:message code="sal.text.cardType" />',
                width : 100,
                editable : true
            },{
                dataField : "crcType",
                headerText : '<spring:message code="sal.title.text.crcType" />',
                width : 100,
                editable : true
            },{
                dataField : "bank",
                headerText : '<spring:message code="sal.title.text.bank" />',
                width : 100,
                editable : true
            }, {
                dataField : "nmCard",
                headerText : '<spring:message code="sal.text.name" />',
                editable : true
            }, {
                dataField : "creditCardNo",
                headerText : '<spring:message code="sal.text.creditCardNo" />',
                width : 100,
                editable : true
            }, {
                dataField : "cardExpiry",
                headerText : '<spring:message code="sal.title.text.expiry" />',
                editable : true
            }, {
                dataField : "cardRem",
                headerText : '<spring:message code="sal.title.remark" />',
                editable : true
            }, {
                dataField : "crcToken",
                editable : false,
                visible : false
            }, {
                dataField : "encryptCardNo",
                editable : false,
                visible : false
            }, {
                dataField : "tokenRefNo",
                editable : false,
                visible : false
            }];

        // bank account
        var columnLayout1 = [
            {
                dataField : "accTypeId",
                headerText : '<spring:message code="sal.title.type" />',
                width : 100,
                editable : true
            },{
                dataField : "accBankId",
                headerText : '<spring:message code="sal.title.text.bank" />',
                width : 100,
                editable : true
            },{
                dataField : "accOwner",
                headerText : '<spring:message code="sal.text.name" />',
                width : 100,
                editable : true
            }, {
                dataField : "accNo",
                headerText : '<spring:message code="sal.text.accNo" />',
                editable : true
            }, {
                dataField : "ddtChnl",
                headerText : '<spring:message code="sal.text.ddcChnl" />',
                width : 100,
                editable : true
            }, {
                dataField : "ddtChnlCde",
                headerText : '<spring:message code="sal.text.ddcChnl" />',
                width : 100,
                visible : false,
                editable : true
            }, {
                dataField : "bankBranch",
                headerText : '<spring:message code="sal.text.bankBranch" />',
                width : 100,
                editable : true
            }, {
                dataField : "accRem",
                headerText : '<spring:message code="sal.title.remark" />',
                editable : true
            }];

        //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
        myGridID = AUIGrid.create("#card_grid", columnLayout, "");
        myGridID1 = AUIGrid.create("#account_grid", columnLayout1, "");

        // 그리드 최초에 빈 데이터 넣음.
        AUIGrid.setGridData(myGridID, []);
        AUIGrid.setGridData(myGridID1, []);
    }

    // 조회조건 combo box
//    function f_multiCombo(){
//        $(function() {
//            $('#_cmbTypeId_').change(function() {
//
//            }).multipleSelect({
//                selectAll: true, // 전체선택
//                width: '80%'
//            });
//            $('#_cmbCorpTypeId').change(function() {
//
//            }).multipleSelect({
//                selectAll: true, // 전체선택
//                width: '80%'
//            });
//
//       });
//    }

    function onChangeCorpType(val){
    	if($("#_cmbTypeId_").val() == '965'){
            //CELESTE - 20240510 - LHDN E-INVOICE [S]

            if($("#_cmbCorpTypeId_ :selected").val() != '1151' ){
                $("#tinTitle").replaceWith("<th scope='row' id='tinTitle'><spring:message code='sal.title.text.tin' /><span class='must'>*</span></th>");
            }
            else{
                $("#tinTitle").replaceWith("<th scope='row' id='tinTitle'><spring:message code='sal.title.text.tin' /></th>");
            }

            //CELESTE - 20240510 - LHDN E-INVOICE [E]
    	}
    	else{
    		$("#tinTitle").replaceWith("<th scope='row' id='tinTitle'><spring:message code='sal.title.text.tin' /></th>");
    	}
    }

    // Customer Type 선택시 Company Type 변경 (Basic Info)
    function onChangeCompanyType(val){

        if($("#_cmbTypeId_").val() == '965'){
            $("select[name=cmbCorpTypeId]").removeAttr("disabled");
            $("select[name=cmbCorpTypeId]").removeClass("w100p disabled");
            $("select[name=cmbCorpTypeId]").addClass("w100p");
            $("#_cmbCorpTypeId_").val('1173');
            $("#tinTitle").replaceWith("<th scope='row' id='tinTitle'><spring:message code='sal.title.text.tin' /><span class='must'>*</span></th>");
            $("#_cmbNation_").val('');
            $("select[name=cmbNation]").addClass("w100p disabled");
            $("select[name=cmbNation]").attr('disabled', 'disabled');
            $("#_cmbRace_").val('');
            $("select[name=cmbRace]").addClass("w100p disabled");
            $("select[name=cmbRace]").attr('disabled', 'disabled');
            $("#_dob_").val('');
//            $("select[name=dob]").attr('readonly','readonly');
            $("#_dob_").attr({'disabled' : 'disabled' , 'class' : 'j_date3 w100p'});
            $("#genderForm").attr('disabled',true);
            $("input:radio[name='gender']:radio[value='M']").prop("checked", false);
            $("input:radio[name='gender']:radio[value='F']").prop("checked", false);
            $("input:radio[name='gender']").attr("disabled" , "disabled");
            $("#genderForm").attr('checked', false);
            $("#_oldNric_").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
            $("#_sstRgistNo_").removeAttr("disabled");
            $("#_sstRgistNo_").removeClass("w100p disabled");

            // LaiKW - 20190903 - Added to hide centralize and ePortal VIP company type, disallow user to select the mentioned company types
            $("#_cmbCorpTypeId_ option[value='1174']").remove();
            $("#_cmbCorpTypeId_ option[value='1333']").remove();
        }else if($("#_cmbTypeId_").val() == '964'){
            $("#_cmbCorpTypeId_").val('');
            $("#_cmbNation_").val('1');
            $("select[name=cmbCorpTypeId]").attr('disabled', 'disabled');
            $("select[name=cmbCorpTypeId]").addClass("w100p disabled");
            $("select[name=cmbNation]").removeClass("w100p disabled");
            $("select[name=cmbNation]").addClass("w100p");
            $("select[name=cmbNation]").removeAttr("disabled");
            $("select[name=cmbRace]").removeClass("w100p disabled");
            $("select[name=cmbRace]").addClass("w100p");
            $("select[name=cmbRace]").removeAttr("disabled");
            $("#_dob_").attr({'disabled' : false , 'class' : 'j_date3 w100p'});
//            $("select[name=dob]").removeAttr("readonly");
            $("#genderForm").removeAttr('disabled');
            $("input:radio[name='gender']").attr("disabled" , false);
            $('input:radio[name="gender"][value="M"]').prop('checked', true);
            $("#_oldNric_").attr({"disabled" : false , "class" : "w100p"});
            $("#tinTitle").replaceWith("<th scope='row' id='tinTitle'><spring:message code='sal.title.text.tin' /></th>");
            $("#_sstRgistNo_").val('');
            $("#_sstRgistNo_").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
        }else{
        	$("#_oldNric_").val('');
        	$("#_oldNric_").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
        	$("#_gstRgistNo_").val('');
            $("#_gstRgistNo_").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
            $("#_cmbNation_").val('');
            $("select[name=cmbNation]").addClass("w100p disabled");
            $("select[name=cmbNation]").attr('disabled', 'disabled');
            $("#genderForm").attr('disabled',true);
            $("input:radio[name='gender']:radio[value='M']").prop("checked", false);
            $("input:radio[name='gender']:radio[value='F']").prop("checked", false);
            $("input:radio[name='gender']").attr("disabled" , "disabled");
            $("#_cmbRace_").val('');
            $("#_cmbRace_").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
            $("#_dob_").val('');
            $("#_dob_").attr({'disabled' : 'disabled' , 'class' : 'j_date3 w100p'});
        }

    }

    function fn_addCreditCardPop(){
       // Common.popupWin("insBasicForm", "/sales/customer/customerAddCreditCardPop.do", option);
        console.log("Check NRIC for CRC");
        if($("#_nric_").val() == ''){
            Common.alert('<spring:message code="sal.alert.msg.plzKeyinNricCompNum" />');
            return false;
        } else {
            Common.popupDiv("/sales/customer/customerAddCreditCardPop.do", $("#insBasicForm").serializeJSON(), null, true, '_cardDiv');
        }
    }

    function fn_addBankAccountPop(){
       // Common.popupWin("insBasicForm", "/sales/customer/customerAddBankAccountPop.do", option);
       Common.popupDiv("/sales/customer/customerAddBankAccountPop.do", $("#insBasicForm").serializeJSON(), null, true, '_bankDiv');
    }


    // save confirm
    function fn_saveConfirm(){

    	console.log("save click");

    	if(fn_saveValidationCheck()){
            Common.confirm("<spring:message code='sys.common.alert.save'/>", fn_saveNewCustomer);
        }
    }

    // save
    function fn_saveNewCustomer(){
        console.log("saveNewCustomer()");

        var custId;

        // [Celeste] 29-05-2024 : move eInvoice flag to bill group
        /* var eInvValue = 0;

        if($('input:checkbox[id="isEInvoice"]').is(":checked") == true){
        	eInvValue = 1;
        }else{
        	eInvValue = 0;
        } */

            var customerForm = {
                dataSet     : GridCommon.getEditData(myGridID),
                dataSetBank     : GridCommon.getEditData(myGridID1),
                customerVO : {
                    cmbTypeId : insBasicForm.cmbTypeId.value,
                    custName : insBasicForm.custName.value,
                    cmbCorpTypeId : insBasicForm.cmbCorpTypeId.value,
                    custInitial : insBasicForm.cmbInitials.value,
                    nric : insBasicForm.nric.value,
                    oldNric : insBasicForm.oldNric.value,
                    gstRgistNo : insBasicForm.gstRgistNo.value,
                    cmbNation : insBasicForm.cmbNation.value,
                    pasSportExpr : insBasicForm.pasSportExpr.value,
                    dob : insBasicForm.dob.value,
                    visaExpr : insBasicForm.visaExpr.value,
                    gender : $('input:radio[name=gender]:checked').val(),
                    email : insBasicForm.email.value,
                    cmbRace : insBasicForm.cmbRace.value,
                    telM1 : insBasicForm.telM1.value,
                    telR : insBasicForm.telR.value,
                    telF : insBasicForm.telF.value,
                    telO : insBasicForm.telO.value,
                    ext : insBasicForm.ext.value,
                    rem : insBasicForm.rem.value,
                    receivingMarketingMsgStatus: insBasicForm.marketingMessageSelection.value,
                    sstRgistNo : insBasicForm.sstRgistNo.value,
                    tin : insBasicForm.tin.value,
                    /* eInvFlg : eInvValue, */ /* [Celeste] 29-05-2024 : move eInvoice flag to bill group */

                    addrDtl : insAddressForm.addrDtl.value,
                    areaId : insAddressForm.areaId.value,
                    streetDtl : insAddressForm.streetDtl.value,
                    addrRem : insAddressForm.addrRem.value,

                    asCustName : insContactForm.asCustName.value,
                    asTelM : insContactForm.asTelM.value,
                    asTelO : insContactForm.asTelO.value,
                    asTelR : insContactForm.asTelR.value,
                    asTelF : insContactForm.asTelF.value,
                    asExt : insContactForm.asExt.value,
                    asEmail : insContactForm.asEmail.value
                }
            };

            console.log(customerForm);

            Common.ajax("POST", "/sales/customer/insCustBasicInfo.do", customerForm, function(result) {

            	if(result != null){
            		$("._custMakeBtn").css("display" , "none");
            	}else{
            		Common.alert('<spring:message code="sal.alert.msg.dupNricNum" />');
            		return;
            	}

                Common.alert("<spring:message code='sys.msg.success'/><br/>" + " Customer ID : " + result , fn_winClose);

                if('${callPrgm}' == 'ORD_REGISTER') {
                    $('#custId').val(result);
                    fn_selectCustInfo();
                }
                if('${callPrgm}' == 'PRE_ORD') {
                    fn_loadCustomer(result, null);
                }
                if('${callPrgm}' == 'PRE_ORD_3PARTY') {
                    fn_loadThirdParty(result, 1);
                }
                if('${callPrgm}' == 'ORD_REGISTER_3PARTY') {
                    fn_loadThirdParty(result, 1);
                }
            }, function(jqXHR, textStatus, errorThrown) {
                Common.alert("실패하였습니다.");
                console.log("실패하였습니다.");
                console.log("error : " + jqXHR + " \n " + textStatus + "\n" + errorThrown);

                alert(jqXHR.responseJSON.message);
                console.log("jqXHR.responseJSON.message" + jqXHR.responseJSON.message);

            });

    }

    function fn_winClose(){

        //window.close();
        $("#_insCloseBtn").click();
    }


    // Validation Check
    function fn_saveValidationCheck(){
    	console.log("1.  type Check");
    	if($("#_cmbTypeId_").val() == ''){
            Common.alert('<spring:message code="sal.alert.msg.plzSelCustType" />');
            return false;
        }
    	 console.log("2.  nric Check");
        if($("#_nric_").val() == ''){
            Common.alert('<spring:message code="sal.alert.msg.plzKeyinNricCompNum" />');
            return false;
        }
        if($("#_cmbTypeId_").val() == '965'){
        	if($("#_cmbCorpTypeId_ :selected").val() != '1151'){

        		var regex1 = new RegExp("^[0-9]+$");
                var str1 = $("#_nric_").val();
                if (regex1.test(str1)) {
                	 if($("#_nric_").val().length != 12){
                         Common.alert('Only allow 12 characters for NRIC/Company No.');
                         return false;
                     }
                	//return true;
                }
                else{
                	Common.alert('Only allow 12 digits for NRIC/Company No.');
                    return false;
                }

        	} else {
        		if($("#_nric_").val().length > 20){
                    Common.alert('Only allow 20 characters for NRIC/Company No.');
                    return false;
                }
        	}
        }else{
        	if($("#_cmbNation_").val() == '1'){
        		// Malaysian NRIC validation
        		var regex = new RegExp("/((([02468][048]|[13579][26])(02)(29))|(([0-9]{2})((0[1-9]|1[0-2])(0[1-9]|1[0-9]|2[0-8])|(0[1|3-9]|1[0-2])(29|30)|(0[13578]|1[02])(31))))([0-9]{2})([0-9]{4})$/");
        		var str = $("#_nric_").val();
                if (regex.test(str)) {
                    //return true;
                }
                else{
                	Common.alert('Invalid format for NRIC/Company No.');
                	return false;
                }
        	}

        	if($("#_nric_").val().length != 12){
                Common.alert('Only allow 12 digits for NRIC/Company No.');
                return false;
            }
        }
        /*else if($("#_nric_") .length > 12){
            Common.alert("IC length More than 12 digit. </br> Are you sure you want to Save?");
        }else{
            if(FormUtil.checkNum($("#_nric_"))){
                Common.alert("* Invalid nric number.");
                return false;
            }
        } */
        console.log("3.  name check");
        if($("#_custName_").val() == ''){
            Common.alert('<spring:message code="sal.alert.msg.plzKeyinCustName" />');
            return false;
        }
        console.log("4.  tel check");
        if($("#_telM1_").val() == '' && $("#_telR_").val() == '' && $("#_telF_").val() == '' && $("#_telO_").val() == '' ){
            Common.alert('<spring:message code="sal.msg.keyInContactNum" />');
            return false;
        }else{
            if($("#_telM1_").val() != ''){
                if(FormUtil.checkNum($("#_telM1_"))){
                    Common.alert('<spring:message code="sal.alert.msg.invaildTelNumM" />');
                    return false;
                } else if($("#_telM1_").val().substring(0,3) == "015"){
                    Common.alert('<spring:message code="sal.alert.msg.incorrectMobilePrefix" />');
                    return false;
               } else if($("#_telM1_").val().substring(0,2) != "01"){
                    Common.alert('<spring:message code="sal.alert.msg.incorrectMobilePrefix" />');
                    return false;
                } else if($("#_telM1_").val().length < 9 || $("#_telM1_").val().length > 12){
                    Common.alert('<spring:message code="sal.alert.msg.incorrectMobileNumberLength" />');
                    return false;
                } else if($("#_telM1_").val().length > 12){
                    Common.alert('<spring:message code="sal.alert.msg.telMNumExceedLengTwelve" />');
                    return false;
                }


            }
            if($("#_telO_").val() != ''){

                   if(FormUtil.checkNum($("#_telO_"))){
                       Common.alert('<spring:message code="sal.alert.msg.invaildTelNumO" />');
                       return false;
                   } else if($("#_telO_").val().length < 9 || $("#_telO_").val().length > 12){
                       Common.alert('<spring:message code="sal.alert.msg.incorrectMobileNumberLength" />');
                       return false;
                   } else if($("#_telO_").val().length > 12){
                       Common.alert('<spring:message code="sal.alert.msg.telONumExceedLengTwelve" />');
                       return false;
                   }
               }
            if($("#_telR_").val() != ''){
                   if(FormUtil.checkNum($("#_telR_"))){
                       Common.alert('<spring:message code="sal.alert.msg.invaildTelNumR" />');
                       return false;
                   } else if($("#_telR_").val().length < 9 || $("#_telR_").val().length > 12){
                       Common.alert('<spring:message code="sal.alert.msg.incorrectMobileNumberLength" />');
                       return false;
                   } else if($("#_telR_").val().length > 12){
                       Common.alert('<spring:message code="sal.alert.msg.telRNumExceedLengTwelve" />');
                       return false;
                   }
               }
            if($("#_telF_").val() != ''){
                   if(FormUtil.checkNum($("#_telF_"))){
                       Common.alert('<spring:message code="sal.alert.msg.invaildTelNumF" />');
                       return false;
                   } else if($("#_telF_").val().length < 9 || $("#_telF_").val().length > 12){
                       Common.alert('<spring:message code="sal.alert.msg.incorrectMobileNumberLength" />');
                       return false;
                   } else if($("#_telF_").val().length > 12){
                       Common.alert('<spring:message code="sal.alert.msg.telFNumExceedLengTwelve" />');
                       return false;
                   }
               }
        }
        console.log("5.  cmb type check");
        if($("#_cmbTypeId_").val() == '964'){
            if($("#_cmbNation_").val() == ''){
                Common.alert('<spring:message code="sal.alert.msg.plzSelNationality" />');
                return false;
            }
            if($("#_dob_").val() == ''){
                Common.alert('<spring:message code="sal.alert.msg.plzKeyinCustDob" />');
                   return false;
            }
            // Gender validation check (해야함.) * Customer is exist.
            if($("#_cmbRace_").val() == ''){
                Common.alert('<spring:message code="sal.alert.msg.plzSelCustRace" />');
                   return false;
            }
            if($("#_cmbInitials_").val() == ''){
                Common.alert('<spring:message code="sal.alert.msg.plzSelCntcPersonInitial" />');
                   return false;
            }
        }
        console.log("6.  detail addr check");
        if($("#_addrDtl_").val() == ''){
            Common.alert('<spring:message code="sal.alert.msg.plzKeyinAddr" />');
            return false;
        }

        console.log("7.  area check");
        if($("#_mArea_").val() == ''){
                Common.alert('<spring:message code="sal.alert.msg.plzKeyinArea" />');
                return false;
        }

        console.log("8.  city check");
        if($("#_mCity_").val() == ''){
            Common.alert('<spring:message code="sal.alert.msg.plzKeyinCity" />');
            return false;
        }

        console.log("9.  postcode check");
        if($("#_mPostCd_").val() == ''){
            Common.alert('<spring:message code="sal.alert.msg.plzKeyinPostcode" />');
            return false;
        }

        console.log("10.  state check");
        if($("#_mState_").val() == ''){
            Common.alert('<spring:message code="sal.alert.msg.plzKeyinState" />');
            return false;
        }

        if($("#areaId").val() == ''){
            Common.alert('Area not found. <br/> Please check with System Administrator.');
            return false;
        }

        console.log("11.  cust name check");
        if($("#_asCustName_").val() == ''){
            $("#_contactTab").click();

        	Common.alert('<spring:message code="sal.alert.msg.plzKeyinCustCntcName" />', fn_focusToCustName);
            return false;
        }
        console.log("12.  contact check");
        if($("#_asTelM_").val() == '' && $("#_asTelR_").val() == '' && $("#_asTelF_").val() == '' && $("#_asTelO_").val() == '' ){
            Common.alert('<spring:message code="sal.msg.keyInContactNum" />');
            return false;
        }else{
            if($("#_asTelM_").val() != ''){
                if(FormUtil.checkNum($("#_asTelM_"))){
                    Common.alert('<spring:message code="sal.alert.msg.invaildTelNumM" />');
                    return false;
                } else if($("#_asTelM_").val().substring(0,3) == "015"){
                	Common.alert('<spring:message code="sal.alert.msg.incorrectMobilePrefix" />');
                    return false;
                }else if($("#_asTelM_").val().substring(0,2) != "01"){
                	Common.alert('<spring:message code="sal.alert.msg.incorrectMobilePrefix" />');
                	return false;
                } else if($("#_asTelM_").val().length < 9 || $("#_asTelM_").val().length > 12){
                	Common.alert('<spring:message code="sal.alert.msg.incorrectMobileNumberLength" />');
                    return false;
                } else if($("#_asTelM_").val().length > 12){
                    Common.alert('<spring:message code="sal.alert.msg.telMNumExceedLengTwelveCustCare" />');
                    return false;
                }
            }
            if($("#_asTelO_").val() != ''){

                   if(FormUtil.checkNum($("#_asTelO_"))){
                       Common.alert('<spring:message code="sal.alert.msg.invaildTelNumO" />');
                       return false;
                   } else if($("#_asTelO_").val().length < 9 || $("#_asTelO_").val().length > 12){
                       Common.alert('<spring:message code="sal.alert.msg.incorrectMobileNumberLength" />');
                       return false;
                   } else if($("#_asTelO_").val().length > 12){
                       Common.alert('<spring:message code="sal.alert.msg.telONumExceedLengTwelveCustCare" />');
                       return false;
                   }
               }
            if($("#_asTelR_").val() != ''){
                   if(FormUtil.checkNum($("#_asTelR_"))){
                       Common.alert('<spring:message code="sal.alert.msg.invaildTelNumR" />');
                       return false;
                   } else if($("#_asTelR_").val().length < 9 || $("#_asTelR_").val().length > 12){
                       Common.alert('<spring:message code="sal.alert.msg.incorrectMobileNumberLength" />');
                       return false;
                   } else if($("#_asTelR_").val().length > 12){
                       Common.alert('<spring:message code="sal.alert.msg.telRNumExceedLengTwelveCustCare" />');
                       return false;
                   }
               }
            if($("#_asTelF_").val() != ''){
                   if(FormUtil.checkNum($("#_asTelF_"))){
                       Common.alert('<spring:message code="sal.alert.msg.invaildTelNumF" />');
                       return false;
                   } else if($("#_asTelF_").val().length < 9 || $("#_asTelF_").val().length > 12){
                       Common.alert('<spring:message code="sal.alert.msg.incorrectMobileNumberLength" />');
                       return false;
                   } else if($("#_asTelF_").val().length > 12){
                       Common.alert('<spring:message code="sal.alert.msg.telFNumExceedLengTwelveCustCare" />');
                       return false;
                   }
               }
        }
        console.log("13.  email check");
        if($("#_email_").val() == ""){

            Common.alert('<spring:message code="sal.alert.msg.plzKeyInEmailAddr" />');

            return false;
        }

        if($("#_cmbTypeId_").val() == '965'){
        	if($("#_cmbCorpTypeId_").val() != "1333" && $("#_cmbCorpTypeId_").val() != "1151"){
                if($("#_tin_").val() == "" || $("#_tin_").val() == null){
                    Common.alert("Please enter Company TIN to proceed.");
                    return false;
                 }
            }
        }

        if($("#_tin_").val() != ""){
        	if($("#_tin_").val().length < 11  || $("#_tin_").val().length > 15){
                Common.alert("Please make sure TIN No is within 11 to 14 characters. ");
                return false;
            }
        }

        if($("#_sstRgistNo_").val() != ""){
        	if($("#_sstRgistNo_").val().length != 17){
                Common.alert("Please make sure SST No is 17 characters. ");
                return false;
            }
        }

        if($('input:checkbox[id="isEInvoice"]').is(":checked") == true && $("#_tin_").val() == ''){
        	Common.alert('Please fill in TIN to receive e-Invoice.');
        	return false;
        }

//      if(!FormUtil.checkNum($("#ext").val())){
//               alert("* Invalid extension number.");
//        }
        return true;
    }

    function fn_focusToCustName(){
    	$("#_asCustName_").focus();
    }

    function fn_copyCustInfo(){
        $("#_asCustName_").val($("#_custName_").val());
        $("#_asTelM_").val($("#_telM1_").val());
        $("#_asTelR_").val($("#_telR_").val());
        $("#_asTelO_").val($("#_telO_").val());
        $("#_asTelF_").val($("#_telF_").val());
        $("#_asExt_").val($("#_ext_").val());
        $("#_asEmail_").val($("#email").val());
    }

    function fn_addCreditCardInfo(ccType,iBank,cardNo,expDate,nameCard,cType,cardRem, crcToken, encCrcNo, refNo){

        console.log("mcpTkns :: fn_addCreditCardInfo");
        var item = new Object();

        if(ccType != "" && iBank != "" && cardNo != "" && expDate != "" && nameCard != "" && cType != "" && crcToken != "" && refNo != ""){
            item.crcType = ccType;
            item.bank = iBank;
            item.creditCardNo = cardNo;
            item.cardExpiry = expDate;
            item.nmCard = nameCard;
            item.cardType = cType;
            item.cardRem = cardRem;
            item.crcToken = crcToken;
            item.encCrcNo = "";
            item.tokenRefNo = refNo;
            AUIGrid.addRow(myGridID, item, "last");
        }
    }

    function fn_addBankAccountInfo(accType,accBank,accNo,bankBranch,accOwner,accRem,ddtChnl,ddtChnlCde){

        var accItem = new Object();

        if(accType != "" && accBank != "" && accNo != "" && accOwner != ""){
            accItem.accTypeId = accType;
            accItem.accBankId = accBank;
            accItem.accNo = accNo;
            accItem.bankBranch = bankBranch;
            accItem.accOwner = accOwner;
            accItem.accRem = accRem;
            accItem.ddtChnl = ddtChnl;
            accItem.ddtChnlCde = ddtChnlCde;
            AUIGrid.addRow(myGridID1, accItem, "last");
        }
    }

    function fn_addMaddr(marea, mcity, mpostcode, mstate, areaid, miso){

        if(marea != "" && mpostcode != "" && mcity != "" && mstate != "" && areaid != "" && miso != ""){

            $("#_mArea_").attr({"disabled" : false  , "class" : "w100p"});
            $("#_mCity_").attr({"disabled" : false  , "class" : "w100p"});
            $("#_mPostCd_").attr({"disabled" : false  , "class" : "w100p"});
            $("#_mState_").attr({"disabled" : false  , "class" : "w100p"});

            //Call Ajax

            CommonCombo.make('_mState_', "/sales/customer/selectMagicAddressComboList", '' , mstate, optionState);

            var cityJson = {state : mstate}; //Condition
            CommonCombo.make('_mCity_', "/sales/customer/selectMagicAddressComboList", cityJson, mcity , optionCity);

            var postCodeJson = {state : mstate , city : mcity}; //Condition
            CommonCombo.make('_mPostCd_', "/sales/customer/selectMagicAddressComboList", postCodeJson, mpostcode , optionCity);

            var areaJson = {groupCode : mpostcode};
            var areaJson = {state : mstate , city : mcity , postcode : mpostcode}; //Condition
            CommonCombo.make('_mArea_', "/sales/customer/selectMagicAddressComboList", areaJson, marea , optionArea);

            $("#areaId").val(areaid);
            $("#_searchDiv").remove();
        }else{
            Common.alert('<spring:message code="sal.alert.msg.addrCheck" />');
        }
    }

    //Get Area Id
    function fn_getAreaId(){

        var statValue = $("#_mState_").val();
        var cityValue = $("#_mCity_").val();
        var postCodeValue = $("#_mPostCd_").val();
        var areaValue = $("#_mArea_").val();



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
//    function fn_nricDupChk(){
//
//      var url = "/sales/customer/nricDupChk.do";
//      var param = {"nric" : insBasicForm.nric.value, "_cmbTypeId" : insBasicForm._cmbTypeId.value};
//      $.ajax({
//          url : url,
//          type : 'POST',
 //         data : param,
 //         success:function(data){
 //             alert(data.dup);
 //         },
 //         error: function(jqXHR, textStatus, errorThrown){
 //           },
 //           complete: function(){
 //           }
 //     },
//      Common.ajax("POST", url, param, function(result) {
//          if(result.dup > 0){
//              Common.alert("This is existing customer.");
//          }else{

//          }
//            Common.alert(result.message);

//        },
//        function(jqXHR, textStatus, errorThrown) {
//            Common.alert("실패하였습니다.");
//            console.log("실패하였습니다.");
//            console.log("error : " + jqXHR + " \n " + textStatus + "\n" + errorThrown);
//
//            alert(jqXHR.responseJSON.message);
//            console.log("jqXHR.responseJSON.message" + jqXHR.responseJSON.message);

//        });
//    }

    function emailCheck(){
        if($("#_email_").val() == ""){

        	Common.alert('<spring:message code="sal.alert.msg.plzKeyInEmailAddr" />');

            return false;
        }else{
            if(FormUtil.checkEmail($("#_email_").val())){
//              $("input[name='email']").focus();
                Common.alert('<spring:message code="sal.alert.msg.invaildEmailAddr" />');

                $("#_email_").val('');

                return false;
            }
        }
    }

    function asEmailCheck(){
        if(FormUtil.checkEmail($("#_asEmail_").val())){
            Common.alert('<spring:message code="sal.alert.msg.invaildEmailAddr" />');
            $("#_asEmail_").val('');
//            $("#asEmail").focus();
            return false;
        }
    }

    function chgTab(tabNm) {
        switch(tabNm) {
            case 'card' :
                AUIGrid.resize(myGridID, 1100, 380);
                break;
            case 'account' :
                AUIGrid.resize(myGridID1, 1100, 380);
                break;
        }
    }

    function fn_addrSearch(){
        if($("#_searchSt_").val() == ''){
            Common.alert('<spring:message code="sal.alert.msg.plzSearch" />');
            return false;
        }
        Common.popupDiv('/sales/customer/searchMagicAddressPop.do' , $('#insAddressForm').serializeJSON(), null , true, '_searchDiv'); //searchSt
    }

    function fn_nricChkAndSuggDob(inputVal){

    	if($("#_cmbTypeId_").val() != '964'){
    		return;
    	}

    	//Dup Check
    	//Init Field
    	var nricObj = {cmbTypeId : $("#_cmbTypeId_").val() , nric : $("#_nric_").val()};

    	var ajaOtp = {
    			async : false
    	};
    	var isDup = false;
    	var msg = '';
    	Common.ajax("POST", "/sales/customer/nricDupChk.do", nricObj, function(result){

    		if(result != null){
    				msg += '<spring:message code="sal.alert.msg.existCustomerBrCustId" />' + result.custId;
    				isDup = true;
    		}
    	}, '', ajaOtp);
    	if(isDup == true){
    		$("#_nric_").val('');
    		Common.alert(msg);
    		return;
    	}
        /****** Validation ********/
        //Init Filed
        $("#_dob_").val('');
        console.log("inputVal : " + inputVal);
        var rtnVal = "";
        //1.number check
        /* if(FormUtil.checkNum($("#_nric_")) == true){
            console.log("Not Numberic.");
            return;
        } */
        //2. Digit
        if(inputVal.length != 12){
            console.log("Length is : " + inputVal.length);
            return;
        }
        //3. Make YYYY
        if(inputVal.substring(0, 2) >  20){
            rtnVal = '19' + inputVal.substring(0, 6);
        }else{
            rtnVal = '20' + inputVal.substring(0, 6);
        }
        //4. Available Date Check
        var year = Number(rtnVal.substring(0, 4));
        var month = Number(rtnVal.substring(4, 6));
        var day = Number(rtnVal.substring(6, 8));

        // Month Check
        if( month<1 || month>12 ) {
            console.log("month failed caused by  month is [: "  + month + "]");
            return;
        }
        var maxDaysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
        var maxDay = maxDaysInMonth[month-1];
        // Leap Year Check
        if( month==2 && ( year%4==0 && year%100!=0 || year%400==0 ) ) {
            maxDay = 29;
        }
        // Day Check
        if( day<=0 || day>maxDay ) {
            console.log("day failed caused by  day is [: "  + day + "]");
            return;
        }

        /***** DOB ******/
        //Return
        year = year + '';
        month = month+'';
        day = day+'';

        if(month.length < 2){
            month = '0'+month;
        }
        if(day.length < 2){
            day = '0'+day;
        }
        rtnVal = day + "/" + month + "/" + year;
        console.log(" create dob : " + rtnVal);
        $("#_dob_").val(rtnVal);


        /***** GENDER ******/
        var genderStr =  inputVal.substring(inputVal.length -1, inputVal.length);
        var genderNum = Number(genderStr);

        if(genderNum % 2 == 0){
            //Female
            $('input:radio[name="gender"][value="F"]').prop('checked', true);
        }else{
            //Male
            $('input:radio[name="gender"][value="M"]').prop('checked', true);
        }
    }

    function fn_validHPCodyContactNumber(contactNumber, fieldId){
    	if(contactNumber != ""){
		    Common.ajax("GET", "/sales/customer/existingHPCodyMobile", {contactNumber : contactNumber} , function(result) {
		        if(result != null){
		            Common.
		            alert("<spring:message code='sal.alert.msg.existingHPCodyMobile' arguments = '" + result.fullName + " ; " + result.memCode+"' htmlEscape='false' argumentSeparator=';' />");
		            //$("#" + fieldId).val('');
		            return;
		        }
		   });
    	}
    }


    $('#_nric_').keypress(function (e) {
        var regex = new RegExp("^[a-zA-Z0-9\s]+$");
        var str = String.fromCharCode(!e.charCode ? e.which : e.charCode);
        if (regex.test(str)) {
            return true;
        }
        e.preventDefault();
        return false;
    });


</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.title.text.newCustomer" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a id="_insCloseBtn"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->
<section class="pop_body"><!-- pop_body start -->

<ul class="right_btns">
    <li><span class="red_text"><spring:message code="sal.title.text.compulsoryField" /></span> <span class="brown_text">#Compulsory Field(For Indvidual Type)</span></li>
</ul>

<section class="tap_wrap mt20"><!-- tap_wrap start -->
<ul class="tap_type1">
    <li><a href="#" class="on"><spring:message code="sal.tap.title.basicInfo" /></a></li>
    <li><a href="#"><spring:message code="sal.text.insAddr" /></a></li>
    <li><a href="#" id="_contactTab"><spring:message code="sal.title.text.additialServiceContact" /></a></li>
    <li><a href="#" onclick="javascript:chgTab('card');"><spring:message code="sal.title.text.creditCard" /></a></li>
    <li><a href="#" onclick="javascript:chgTab('account');"><spring:message code="sal.title.text.bankAccount" /></a></li>
</ul>
<!-- dup Nric Check  -->
<article class="tap_area"><!-- tap_area start -->
<form id="insBasicForm" name="insBasicForm" method="POST">
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
            <th scope="row"><spring:message code="sal.text.custType" /><span class="must">*</span></th>
            <td>
                <select class="w100p"  id="_cmbTypeId_" name="cmbTypeId" onchange="onChangeCompanyType(this.value)">
                </select>
            </td>
            <th scope="row"><spring:message code="sal.title.text.companyType" /></th>
            <td id="corpTypeForm">
                <select class="w100p disabled" id="_cmbCorpTypeId_" name="cmbCorpTypeId" onchange="onChangeCorpType(this.value)" disabled="disabled">
                </select>
            </td>
        </tr>
        <tr>
            <th scope="row"><spring:message code="sal.text.initial" /><span class="must">*</span></th>
            <td>
                <select class="w100p" id="_cmbInitials_" name="cmbInitials"></select>
            </td>
            <th scope="row"><spring:message code="sal.title.text.oldIcarmyPolice" /></th>
            <td >
                <input type="text" title="" id="_oldNric_" name="oldNric" maxlength="30"  placeholder="Old IC/Army/Police" class="w100p"  disabled="disabled" />
            </td>
        </tr>
        <tr>
            <th scope="row"><spring:message code="sal.text.custName" /><span class="must">*</span></th>
            <td colspan="3">
                <input type="text" title="" id="_custName_" name="custName" placeholder="Customer Name" class="w100p" />
            </td>
        </tr>
        <tr>
            <th scope="row"><spring:message code="sal.title.text.nricCompNo" /><span class="must">*</span></th>
            <td>
                <input type="text" title="" id="_nric_" name="nric" maxlength="30" placeholder="NRIC/Company No" class="w100p" onblur="javascript: fn_nricChkAndSuggDob(this.value)" />
            </td>
            <th scope="row"><spring:message code="sal.text.gstRegistrationNo" /></th>
            <td>
                <input type="text" title="" id="_gstRgistNo_" name="gstRgistNo" placeholder="GST Registration No" class="w100p readonly" disabled="disabled" />
            </td>
        </tr>
        <tr>
            <th scope="row"><spring:message code="sal.title.text.sstRegistrationNo" /></th>
            <td>
                <!-- <input type="text" title="" id="_sstRgistNo_" name="sstRgistNo" maxlength="30" placeholder="SST Registration No" class="w100p" onblur="javascript: fn_nricChkAndSuggDob(this.value)" /> -->
                <input type="text" title="" id="_sstRgistNo_" name="sstRgistNo" maxlength="17" placeholder="SST Registration No" class="w100p" onblur="javascript: fn_nricChkAndSuggDob(this.value)" />
            </td>
            <th scope="row" id="tinTitle"><spring:message code="sal.title.text.tin" /></th>
            <td>
                <input type="text" title="" id="_tin_" name="tin" maxlength="14" placeholder="TIN" class="w100p" />
            </td>
        </tr>
        <tr>
            <th scope="row"><spring:message code="sal.text.nationality" /><span class="brown_text">#</span></th>
            <td>
                <select class="w100p disabled" id="_cmbNation_" name="cmbNation" disabled="disabled">
                </select>
            </td>
            <th scope="row"><spring:message code="sal.text.passportExpire" /></th>
            <td>
                <input type="text" title="Create start Date" id="_pasSportExpr_" name="pasSportExpr" placeholder="DD/MM/YYYY" class="j_date" />
            </td>
        </tr>
        <tr>
            <th scope="row"><spring:message code="sal.text.dob" /><span class="brown_text">#</span></th>
            <td>
                <input type="text" id="_dob_" name="dob" title="Create start Date" placeholder="Date Of Brith" class="j_date3 w100p"  disabled="disabled"/>
            </td>
            <th scope="row"><spring:message code="sal.text.visaExpire" /></th>
            <td>
                <input type="text" id="_visaExpr_" name="visaExpr" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" />
            </td>
        </tr>
        <tr>
            <th scope="row"><spring:message code="sal.text.gender" /><span class="brown_text">#</span></th>
            <td>
                <div id="genderForm" >
                <label><input type="radio" name="gender"  value="M" disabled="disabled"/><span><spring:message code="sal.title.text.male" /></span></label>
                <label><input type="radio" name="gender"  value="F" disabled="disabled"/><span><spring:message code="sal.title.text.female" /></span></label>
                </div>
            </td>
            <th scope="row"><spring:message code="sal.title.text.eamilOne" /><span class="must">*</span></th>
            <td>
              <input type="text" id="_email_" name="email" title="" onBlur="javascript:emailCheck()" placeholder="Email" class="w100p" />
            </td>
        </tr>
        <tr>
            <th scope="row"><spring:message code="sal.text.race" /><span class="brown_text">#</span></th>
            <td>
                <select class="w100p disabled" id="_cmbRace_" name="cmbRace" disabled="disabled">
                </select>
            </td>
            <th scope="row"><spring:message code="sal.title.text.telMOne" /><span class="must">*</span></th>
            <td>
                <input type="text" id="_telM1_" name="telM1" maxlength="11" title="" placeholder="Telephone Number (Mobile)" class="w100p" onblur="javascript: fn_validHPCodyContactNumber(this.value,this.id);"/>
            </td>
        </tr>
        <tr>
            <th scope="row"><spring:message code="sal.title.text.telROne" /><span class="must">*</span></th>
            <td>
            <input type="text" id="_telR_" name="telR" maxlength="11" title="" placeholder="Telephone Number (Residence)" class="w100p" onblur="javascript: fn_validHPCodyContactNumber(this.value,this.id);"/>
            </td>
            <th scope="row"><spring:message code="sal.title.text.telFOne" /><span class="must">*</span></th>
            <td>
            <input type="text" id="_telF_" name="telF" maxlength="11" title="" placeholder="Telephone Number (Fax)" class="w100p" onblur="javascript: fn_validHPCodyContactNumber(this.value,this.id);"/>
            </td>
        </tr>
        <tr>
            <th scope="row"><spring:message code="sal.title.text.telOOne" /><span class="must">*</span></th>
            <td>
            <input type="text" id="_telO_" name="telO" maxlength="11" title="" placeholder="Telephone Number (Office)" class="w100p" onblur="javascript: fn_validHPCodyContactNumber(this.value,this.id);"/>
            </td>
            <th scope="row"><spring:message code="sal.title.text.extNo" /></th>
            <td>
            <input type="text" id="_ext_" name="ext" title="" placeholder="Extension Number" class="w100p" />
            </td>
        </tr>
        <tr>
        <th scope="row">Receiving Marketing Message</th>
		    <td>
		    <div style="display:inline-block;width:100%;">
			    <div style="display:inline-block;">
					<input id="marketMessageYes" type="radio" value="1" name="marketingMessageSelection" checked/><label for="marketMessageYes">Yes</label>
			    </div>
			      <div style="display:inline-block;">
				    <input  id="marketMessageNo" type="radio" value="0" name="marketingMessageSelection"/><label for="marketMessageNo">No</label>
			    </div>
		    </div>
			</td>
		<th scope="row"></th>
        <td></td>
		<!-- [Celeste] 29-05-2024 : move eInvoice flag to bill group -->
		<%-- <th scope="row"><spring:message code="sal.text.eInvoicFlag" /></th>
	    <td>
	        <c:choose>
	        <c:when test="${result.eInvFlg eq '1'}">
	            <input id="isEInvoice" name="isEInvoice" type="checkbox"  checked />
	        </c:when>
	        <c:otherwise>
	            <input id="isEInvoice" name="isEInvoice" type="checkbox" />
	        </c:otherwise>
	        </c:choose>
	    </td> --%>
        </tr>
        <tr>
            <th scope="row"><spring:message code="sal.title.remark" /></th>
            <td colspan="3">
            <textarea cols="20" rows="5" id="_rem_" name="rem" placeholder="Remark"></textarea>
            </td>
        </tr>
    </tbody>
    </table><!-- table end -->
</form>

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onclick="fn_saveConfirm()" class="_custMakeBtn"><spring:message code="sal.btn.save" /></a></p></li>
</ul>


</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<aside class="title_line"><!-- title_line start -->
<h2><spring:message code="sal.text.instAddr" /></h2>
</aside><!-- title_line end -->

<form id="insAddressForm" name="insAddressForm" method="POST">
    <input type="hidden" id="areaId" name="areaId">
    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:135px" />
        <col style="width:*" />
        <col style="width:130px" />
        <col style="width:*" />
    </colgroup>
         <tbody>
            <tr>
                <th scope="row" ><spring:message code="sal.text.addressDetail" /><span class="must">*</span></th>
                <td colspan="3">
                <input type="text" title="" id="_addrDtl_" name="addrDtl" placeholder="eg. NO 10/UNIT 13-02-05/LOT 33945" class="w100p"  />
                </td>
            </tr>
            <tr>
                <th scope="row" ><spring:message code="sal.text.street" /></th>
                <td colspan="3">
                <input type="text" title="" id="_streetDtl_" name="streetDtl" placeholder="eg. TAMAN/JALAN/KAMPUNG" class="w100p"  />
                </td>
            </tr>
            <tr>
            <th scope="row"><spring:message code="sal.text.country" /><span class="must">*</span></th>
                <td colspan="3">
                <input type="text" title="" id="_mCountry_" name="mCountry" placeholder="" class="w100p readonly" readonly="readonly" value="Malaysia"/>
                </td>
            </tr>
            <tr>
                <th scope="row"><spring:message code="sal.text.state1" /><span class="must">*</span></th>
                <td>
                <select class="w100p" id="_mState_"  name="mState" onchange="javascript : fn_selectState(this.value)"></select>
                </td>
                 <th scope="row"><spring:message code="sal.text.city2" /><span class="must">*</span></th>
                <td>
                <select class="w100p" id="_mCity_"  name="mCity" onchange="javascript : fn_selectCity(this.value)"></select>
                </td>
            </tr>
            <tr>
                <th scope="row"><spring:message code="sal.title.text.areaSearch"/><span class="must">*</span></th>
                <td colspan="3">
                <input type="text" title="" id="_searchSt_" name="searchSt" placeholder="eg. TAMAN RIMBA" class="w50p disabled" disabled/><a href="#" onclick="fn_addrSearch()" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
                </td>
            </tr>
            <tr>
                <th scope="row"><spring:message code="sal.text.postCode3" /><span class="must">*</span></th>
                <td>
                <select class="w100p" id="_mPostCd_"  name="mPostCd" onchange="javascript : fn_selectPostCode(this.value)"></select>
                </td>
               <th scope="row"><spring:message code="sal.text.area4" /><span class="must">*</span></th>
                <td>
                <select class="w100p" id="_mArea_"  name="mArea" onchange="javascript : fn_getAreaId()"></select>
                </td>
            </tr>
            <tr>
                <th scope="row"><spring:message code="sal.text.remarks" /></th>
                <td colspan="3">
                <textarea cols="20" rows="5" id="_addrRem_" name="addrRem" placeholder="Remark"></textarea>
                </td>
            </tr>
        </tbody>
    </table><!-- table end -->
</form>
<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onclick="fn_saveConfirm()" class="_custMakeBtn"><spring:message code="sal.btn.save2" /></a></p></li>
</ul>

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<aside class="title_line"><!-- title_line start -->
<h2><spring:message code="sal.text.instAddr" /></h2>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" onclick="fn_copyCustInfo()"><spring:message code="sal.title.text.copyFromCustInfo" /></a></p></li>
</ul>
</aside><!-- title_line end -->

<form id="insContactForm" name="insContactForm" method="POST">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.name" /><span class="must">*</span></th>
    <td colspan="3">
    <input type="text" id="_asCustName_" name="asCustName" title="" placeholder="Name" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.telMTwo" /><span class="must">*</span></th>
    <td>
    <input type="text" id="_asTelM_" name="asTelM" maxlength="11" title="" placeholder="Telephone Number (Mobile)" class="w100p" onblur="javascript: fn_validHPCodyContactNumber(this.value,this.id);"/>
    </td>
    <th scope="row"><spring:message code="sal.title.text.telRTwo" /><span class="must">*</span></th>
    <td>
    <input type="text" id="_asTelR_" name="asTelR" maxlength="11" title="" placeholder="Telephone Number (Residence)" class="w100p" onblur="javascript: fn_validHPCodyContactNumber(this.value,this.id);"/>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.telOTwo" /><span class="must">*</span></th>
    <td>
    <input type="text" id="_asTelO_" name="asTelO" maxlength="11" title="" placeholder="Telephone Number (Office)" class="w100p" onblur="javascript: fn_validHPCodyContactNumber(this.value,this.id);"/>
    </td>
    <th scope="row"><spring:message code="sal.title.text.ext" /></th>
    <td>
    <input type="text" id="_asExt_" name="asExt" title="" placeholder="Extension Number" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.telFTwo" /><span class="must">*</span></th>
    <td>
    <input type="text" id="_asTelF_" name="asTelF" maxlength="11" title="" placeholder="Telephone Number (Fax)" class="w100p" onblur="javascript: fn_validHPCodyContactNumber(this.value,this.id);"/>
    </td>
    <th scope="row"><spring:message code="sal.title.text.emailTwo" /></th>
    <td>
    <input type="text" id="_asEmail_" name="asEmail" title="" onBlur="javascript:asEmailCheck()" placeholder="Email" class="w100p" />
    </td>
</tr>
</tbody>
</table><!-- table end -->
</form>
<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onclick="fn_saveConfirm()" class="_custMakeBtn"><spring:message code="sal.btn.save" /></a></p></li>
</ul>

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->
<ul class="right_btns">
    <li><p class="btn_grid"><a href="#" onclick="fn_addCreditCardPop()"><spring:message code="sal.title.text.addCrdCard" /></a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="card_grid" style="width:100%; height:380px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onclick="fn_saveConfirm()" class="_custMakeBtn"><spring:message code="sal.btn.save" /></a></p></li>
</ul>
</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->
<ul class="right_btns" >
    <li><p class="btn_grid"><a href="#" onclick="fn_addBankAccountPop()"><spring:message code="sal.title.addBankAccount" /></a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="account_grid" style="width:100%; height:380px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onclick="fn_saveConfirm()" class="_custMakeBtn"><spring:message code="sal.btn.save" /></a></p></li>
</ul>

</article><!-- tap_area end -->

</section><!-- tap_wrap end -->
</section><!-- pop_body end -->
</div>