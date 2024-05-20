<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<script type="text/javaScript" language="javascript" >

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

    $(document).ready(function(){

    	$("#wrap").css({"min-width":"100%"});
        $("#container").css({"min-width":"100%"});

        // 20190925 KR-OHK Moblie Popup Setting
        Common.setMobilePopup(false, false, '');

        if(Common.checkPlatformType() == "mobile") {
        	$('#popup_wrap').addClass("popup_wrap");
        } else {
        	$('#popup_wrap').addClass("popup_wrap pop_win");
        }

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


        AUIGrid.setSelectionMode(myGridID, "singleRow");

        // 셀 더블클릭 이벤트 바인딩

        // 셀 클릭 이벤트 바인딩

        //Magic Address
        fn_initAddress(); //init
      //  CommonCombo.make('_mState_', "/sales/customer/selectMagicAddressComboList", '' , '', optionState);
         //f_multiCombo 함수 호출이 되어야만 multi combo 화면이 안깨짐.
     //   doGetCombo('/common/selectCodeList.do', '8', '964','_cmbTypeId_', 'S' , '');                              // Customer Type Combo Box
        doGetCombo('/common/selectCodeList.do', '8', '','_cmbTypeId_', 'S' , '');                              // Customer Type Combo Box
        doGetCombo('/sales/customer/getNationList', '338' , '1' ,'_cmbNation_' , 'S');        // Nationality Combo Box
        doGetCombo('/common/selectCodeList.do', '95', '','_cmbCorpTypeId_', 'S' , '');                      // Company Type Combo Box
        doGetCombo('/common/selectCodeList.do', '17', '','_cmbInitials_', 'S' , '');                             // Initials Combo Box
    //    doGetCombo('/common/selectCodeList.do', '2', '','_cmbRace_', 'S' , '');                                 // Race Combo Box
    //    doGetCombo('/common/selectCodeList.do', '20', '','cmbBankType', 'S' , '');                         // Add Bank Type Combo Box
       // getAddrRelay('mstate' , '1' , 'state', '');

        //temp for individual only
        /********************************************************/
      //  $("#_cmbTypeId_").val($('input[name=cmbTypeId]:checked').val());
        $("#_cmbTypeId_").val();

        $("#_nric_").val('${nric}');

        onChangeCompanyType($("#_cmbTypeId_").val());
        onChangeNation($("#_cmbNation_").val());
        fn_nricChkAndSuggDob($("#_nric_").val());

      //UpperCase Field
        $("#_nric_").bind("keyup", function(){$(this).val($(this).val().toUpperCase());});
        $("#_custName_").bind("keyup", function(){$(this).val($(this).val().toUpperCase());});
        $("#_asCustName_").bind("keyup", function(){$(this).val($(this).val().toUpperCase());});

        /********************************************************/

        //Enter Event
        $('#_searchSt_').keydown(function (event) {
            if (event.which === 13) {    //enter
                fn_addrSearch();
            }
        });

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

        }else{

            $("#_mPostCd_").attr({"disabled" : false  , "class" : "w100p"});

            $('#_mArea_').append($('<option>', { value: '', text: '4. Area' }));
            $('#_mArea_').val('');
            $("#_mArea_").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});

            //Call ajax
            var postCodeJson = {state : $("#_mState_").val() , city : tempVal}; //Condition
            CommonCombo.make('_mPostCd_', "/sales/customer/selectMagicAddressComboList", postCodeJson, '' , optionPostCode);
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

    function fn_radioButton(val){


    	var _cmbTypeId_ = val;
    	console.log ("val:" + _cmbTypeId_);

        if(val == 965) {



        	$("#_cmbInitials_").hide();
        	$("#_cmbInitials_title").hide();

            /* $("#grid_wrap_dtSubGroup").show();
            $("#grid_wrap_dtaAreaSubGroup").hide();
            // 버튼 보이게 한다.
            $("#hiddenBtn1").show();
            $("#hiddenBtn2").show();
            $("#hiddenBtn3").show();

            AUIGrid.resize(myGridID); */

        } else {

        	$("#_cmbInitials_").show();
        	$("#_cmbInitials_title").show();
            /* $("#grid_wrap_dtaAreaSubGroup").show();
            $("#grid_wrap_dtSubGroup").hide();
            // 버튼 안보이게 한다.
            $("#hiddenBtn1").hide();
            $("#hiddenBtn2").hide();
            $("#hiddenBtn3").hide();

            AUIGrid.resize(myGridID2); */
        }
    }
    // Customer Type 선택시 Company Type 변경 (Basic Info)
   function onChangeCompanyType(val){
        if($("#_cmbTypeId_").val() == '965'){ // Company
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


        }else if($("#_cmbTypeId_").val() == '964'){ // individual
            $("#_cmbCorpTypeId_").val('');
            $("#_cmbNation_").val('1');
            $("select[name=cmbCorpTypeId]").attr('disabled', 'disabled');
            $("select[name=cmbCorpTypeId]").addClass("w100p disabled");
            /* $("select[name=cmbNation]").removeClass("w100p disabled");
            $("select[name=cmbNation]").addClass("w100p");
            $("select[name=cmbNation]").removeAttr("disabled"); */
            if($("#_nric_").val().length != 12){
            	$("#_cmbNation_").val('');
                $("select[name=cmbNation]").removeAttr("disabled");
                $("select[name=cmbNation]").removeClass("w100p disabled");
                $("select[name=cmbNation]").addClass("w100p");
                $("#_pasSportExpr_").attr({'disabled' : false , 'class' : 'j_date w100p'});
                $("#_visaExpr_").attr({'disabled' : false , 'class' : 'j_date w100p'});
                $(".foreigner").show();
            }else{
            	$("#_pasSportExpr_").attr({'disabled' : true , 'class' : 'j_date w100p'});
                $("#_visaExpr_").attr({'disabled' : true , 'class' : 'j_date w100p'});
            	$(".foreigner").hide();
            }

            $("select[name=cmbRace]").removeClass("w100p disabled");
            $("select[name=cmbRace]").addClass("w100p");
            $("select[name=cmbRace]").removeAttr("disabled");
          //  $("select[name=dob]").removeAttr("readonly");
            $("#_dob_").attr({'disabled' : false , 'class' : 'j_date3 w100p'});
            $("#genderForm").removeAttr('disabled');
            $("input:radio[name='gender']").attr("disabled" , false);
           // $('input:radio[name="gender"][value="M"]').prop('checked', true);
            $("#_oldNric_").attr({"disabled" : false , "class" : "w100p"});


            if($("#_nric_").val().startsWith("TST")){
            	$("#_dob_").attr({'disabled' : false , 'class' : 'j_date3 w100p'});
            	$("#genderForm").removeAttr('disabled');
                $("input:radio[name='gender']").attr("disabled" , false);
                $('input:radio[name="gender"][value="M"]').prop('checked', true);
            }

            $("#_nric_").attr({"disabled" : true , "class" : "w100p"});
            $("#tinTitle").replaceWith("<th scope='row' id='tinTitle'><spring:message code='sal.title.text.tin' /></th>");
        }else{
            $("#_oldNric_").val('');
            $("#_oldNric_").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
            $("#_gstRgistNo_").val('');
            $("#_gstRgistNo_").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
            $("#_cmbNation_").val('');
            $("select[name=cmbNation]").addClass("w100p disabled");
            $("select[name=cmbNation]").attr('disabled', 'disabled');

            $("#_cmbRace_").val('');
            $("#_cmbRace_").attr({"disabled" : "disabled" , "class" : "w100p disabled"});

            if(MEM_TYPE = 2){
            	$("#genderForm").attr('disabled',true);
	            $("input:radio[name='gender']:radio[value='M']").prop("checked", false);
	            $("input:radio[name='gender']:radio[value='F']").prop("checked", false);
	            $("input:radio[name='gender']").attr("disabled" , "disabled");

	            $("#_dob_").val('');
	            $("#_dob_").attr({'disabled' : 'disabled' , 'class' : 'j_date3 w100p'});
            }
        }

    }

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

   function onChangeNation(val){
       if($("#_cmbNation_").val() == '1'){ // MALAYSIAN
	       $("#_pasSportExpr_").attr({'disabled' : true , 'class' : 'j_date w100p'});
	       $("#_visaExpr_").attr({'disabled' : true , 'class' : 'j_date w100p'});
	       $(".foreigner").hide();
       }else{
           $("#_pasSportExpr_").attr({'disabled' : false , 'class' : 'j_date w100p'});
           $("#_visaExpr_").attr({'disabled' : false , 'class' : 'j_date w100p'});
           $(".foreigner").show();
       }
   }

    function fn_addCreditCardPop(){
        Common.popupDiv("/sales/customer/customerAddCreditCardeSalesPop.do", $("#insBasicForm").serializeJSON(), null, true, "_cardDiv");
    }

    function fn_addBankAccountPop(){
        Common.popupDiv('/sales/customer/customerAddBankAccountPop.do', $('#insBasicForm').serializeJSON(), null, true, '_bankDiv');
    }


    // save confirm
    function fn_saveConfirm(){

        console.log("save click");

        if(fn_saveValidationCheck()){

            Common.confirm("<spring:message code='sal.alert.savePreOrdCust'/>" + "<br/>" + $('#_custName_').val() + "<br/>" +  $('#_nric_').val() + "<br/>", fn_saveNewCustomer);
        }
    }

    // save
    function fn_saveNewCustomer(){

    	var eInvValue = 0;

        if($('input:checkbox[id="isEInvoice"]').is(":checked") == true){
            eInvValue = 1;
        }else{
            eInvValue = 0;
        }

        console.log("eInvoice Flag: " + eInvValue);

            var customerForm = {
                dataSet     : GridCommon.getEditData(myGridID),
                dataSetBank     : GridCommon.getEditData(myGridID1),
                customerVO : {
                  //  cmbTypeId : $('input[name=cmbTypeId]:checked').val(),//insBasicForm.cmbTypeId.value,
                    cmbTypeId : $("#_cmbTypeId_").val(),
                    custName : insBasicForm.custName.value,
                    cmbCorpTypeId : insBasicForm.cmbCorpTypeId.value,
                    custInitial : insBasicForm.cmbInitials.value,
                    nric : insBasicForm.nric.value,
                    //oldNric : insBasicForm.oldNric.value,
                    //gstRgistNo : insBasicForm.gstRgistNo.value,
                    cmbNation : insBasicForm.cmbNation.value,
                    pasSportExpr : insBasicForm.pasSportExpr.value,
                    dob : insBasicForm.dob.value,
                    visaExpr : insBasicForm.visaExpr.value,
                    gender : $('input:radio[name=gender]:checked').val(),
                    email : insBasicForm.email.value,
                    cmbRace : $('input[name=cmbRace]:checked').val(), //insBasicForm.cmbRace.value,
                    telM1 : insBasicForm.telM1.value,
                    telR : insBasicForm.telR.value,
                    //telF : insBasicForm.telF.value,
                    telO : insBasicForm.telO.value,
                    ext : insBasicForm.ext.value,
                    //rem : insBasicForm.rem.value,
                    sstRgistNo : insBasicForm.sstRgistNo.value,
                    tin : insBasicForm.tin.value,
                    eInvFlg : eInvValue,

                    addrDtl : null,//insAddressForm.addrDtl.value,
                    areaId : null, //insAddressForm.areaId.value,
                    streetDtl : null, //insAddressForm.streetDtl.value,
                    addrRem : null, //insAddressForm.addrRem.value,

                    asCustName : insContactForm.asCustName.value,
                    asTelM : insContactForm.asTelM.value,
                    asTelO : insContactForm.asTelO.value,
                    asTelR : insContactForm.asTelR.value,
                    //asTelF : insContactForm.asTelF.value,
                    asExt : insContactForm.asExt.value,
                    asEmail : insContactForm.asEmail.value,
                    receivingMarketingMsgStatus   : $('input:radio[name="marketingMessageSelection"]:checked').val()
                }
            };

            console.log(customerForm);

            Common.ajax("POST", "/sales/customer/insCustBasicInfoEkeyin.do", customerForm, function(result) {

                if(result != null){
                    $("._custMakeBtn").css("display" , "none");
                }else{
                    Common.alert('<spring:message code="sal.alert.msg.dupNricNum" />');
                    return;
                }
                Common.alert("<spring:message code='sal.alert.text.saveCustomerSuccess'/><br/><spring:message code='sal.alert.text.plzKeyInOrdInfo'/><br/>" + " Customer ID : " + result , fn_winClose);

                console.log("Save Customer :: callPrgm :: " + '${callPrgm}');
                if('${callPrgm}' == 'ORD_REGISTER') {
                    $('#custId').val(result);
                    fn_selectCustInfo();
                }
                if('${callPrgm}' == 'PRE_ORD') {
                   // fn_loadCustomer(result, null);
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

    function fn_winClose2(){
        window.opener.$('#nric').prop("readonly", false).removeClass("readonly");
        window.opener.$('#sofNo').prop("readonly", false).removeClass("readonly");
        window.opener.$('#btnConfirm').removeClass("blind");
        window.opener.$('#btnClear').removeClass("blind");
        window.close();
    };

    function fn_winClose(){
        //Parent Reload Method Call
        $("#_insCloseBtn").click();
        window.opener.$("#btnConfirm").click();
        window.close();
    }

    // Validation Check
    function fn_saveValidationCheck(){

    	console.log("1.  type Check ::"+ $("#_cmbTypeId_").val());
        if($("#_cmbTypeId_").val() == ''){
            Common.alert('<spring:message code="sal.alert.msg.plzSelCustType" />');
            return false;
        }

         console.log("2.  nric Check ::" + $("#_nric_").val());
        if($("#_nric_").val() == ''){
            Common.alert('<spring:message code="sal.alert.msg.plzKeyinNricCompNum" />');
            return false;
        }
        /*else if($("#_nric_"). length > 12){
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

        console.log("3B.  tel check on Tel(Mobile)"); // Compalsary on Mobile number
        if(FormUtil.isEmpty($("#_telM1_").val())){
        	Common.alert('<spring:message code="sal.msg.keyInTelMComp" />');
            return false;
        }

        console.log("4.  tel check");
        if(FormUtil.isEmpty($("#_telM1_").val()) && FormUtil.isEmpty($("#_telR_").val()) && FormUtil.isEmpty($("#_telF_").val()) && FormUtil.isEmpty($("#_telO_").val()) ){
            Common.alert('<spring:message code="sal.msg.keyInContactNum" />');
            return false;
        }else{
            if($("#_telM1_").val() != ''){
                if(FormUtil.checkNum($("#_telM1_")) ){
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
                } else if($("#_telM1_").length > 12){
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
                   } else if($("#_telO_").length > 20){
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
                   }  else if($("#_telR_").length > 20){
                       Common.alert('<spring:message code="sal.alert.msg.telRNumExceedLengTwelve" />');
                       return false;
                   }
               }
           /* if($("#_telF_").val() != ''){

                   if(FormUtil.checkNum($("#_telF_"))){
                       Common.alert('<spring:message code="sal.alert.msg.invaildTelNumF" />');
                       return false;
                   }  else if($("#_telF_").val().length < 9 || $("#_telF_").val().length > 12){
                       Common.alert('<spring:message code="sal.alert.msg.incorrectMobileNumberLength" />');
                       return false;
                   }  else if($("#_telF_").length > 20){
                       Common.alert('<spring:message code="sal.alert.msg.telFNumExceedLengTwelve" />');
                       return false;
                   }
               } */
        }
        console.log("5.  cmb type check for 964 ");
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
            if(!$('input[name=cmbRace]:checked').val()){//if($("#_cmbRace_").val() == ''){
                Common.alert('<spring:message code="sal.alert.msg.plzSelCustRace" />');
                   return false;
            }
            if($("#_cmbInitials_").val() == ''){
                Common.alert('<spring:message code="sal.alert.msg.plzSelCntcPersonInitial" />');
                   return false;
            }

            console.log("5A. foreigner check");//aaaaaaaaaaaaaaaaaa
            if($("#_cmbNation_").val() != "1" ){
                if($("#_pasSportExpr_").val() == ''){
                    Common.alert('<spring:message code="sal.alert.msg.plzKeyinPassportExp" />');
                       return false;
                }
                if($("#_visaExpr_").val() == ''){
                    Common.alert('<spring:message code="sal.alert.msg.plzKeyinVisaExp" />');
                       return false;
                }
                if(!$('input[name=gender]:checked').val()){
                    Common.alert('<spring:message code="sal.alert.msg.plzKeyinGender" />');
                    return false;
                }
            }
        }

        console.log("5B.  cmb type check for 965 ");// For company

        if($("#_cmbTypeId_").val() == '965'){
        	 if($("#_email_").val() == ""){
        		 Common.alert('<spring:message code="sal.alert.msg.invaildEmailAddr" />');
        		 return false
             }else{
                 if(FormUtil.checkEmail($("#_email_").val())){
//                   $("input[name='email']").focus();
                     Common.alert('<spring:message code="sal.alert.msg.invaildEmailAddr" />');
                     $("#_email_").val('');
                     return false;
                 }
             }
        }
        /* console.log("6.  detail addr check");
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
        } */

        console.log("12.  cust name check");
        if($("#_asCustName_").val() == ''){
            $("#_contactTab").click();

            Common.alert('<spring:message code="sal.alert.msg.plzKeyinCustCntcName" />', fn_focusToCustName);
            return false;
        }else{
            if($("#_asTelM_").val() != ''){
                if(FormUtil.checkNum($("#_asTelM_"))){
                    Common.alert('<spring:message code="sal.alert.msg.invaildTelNumM" />');
                    return false;
                }else if($("#_asTelM_").val().substring(0,3) == "015"){
                    Common.alert('<spring:message code="sal.alert.msg.incorrectMobilePrefix" />');
                    return false;
                }else if($("#_asTelM_").val().substring(0,2) != "01"){
                    Common.alert('<spring:message code="sal.alert.msg.incorrectMobilePrefix" />');
                    return false;
                } else if($("#_asTelM_").val().length < 9 || $("#_asTelM_").val().length > 12){
                    Common.alert('<spring:message code="sal.alert.msg.incorrectMobileNumberLength" />');
                    return false;
                } else if($("#_asTelM_").length > 12){
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
                   }  else if($("#_asTelO_").length > 12){
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
                   }  else if($("#_asTelR_").length > 12){
                       Common.alert('<spring:message code="sal.alert.msg.telRNumExceedLengTwelveCustCare" />');
                       return false;
                   }
               }
          /*   if($("#_asTelF_").val() != ''){

                   if(FormUtil.checkNum($("#_asTelF_"))){
                       Common.alert('<spring:message code="sal.alert.msg.invaildTelNumF" />');
                       return false;
                   } else if($("#_asTelF_").val().length < 9 || $("#_asTelF_").val().length > 12){
                       Common.alert('<spring:message code="sal.alert.msg.incorrectMobileNumberLength" />');
                       return false;
                   }  else if($("#_asTelF_").length > 12){
                       Common.alert('<spring:message code="sal.alert.msg.telFNumExceedLengTwelveCustCare" />');
                       return false;
                   }
               } */
        }
        console.log("13.  contact check");
/*         if($("#_asTelM_").val() == '' && $("#_asTelR_").val() == '' && $("#_asTelF_").val() == '' && $("#_asTelO_").val() == '' ){
            Common.alert('<spring:message code="sal.msg.keyInContactNum" />');
            return false;
        } */

//      if(!FormUtil.checkNum($("#ext").val())){
//               alert("* Invalid extension number.");
//        }




        console.log("14.  email check");
        if($("#_email_").val() == ""){

            Common.alert('<spring:message code="sal.alert.msg.plzKeyInEmailAddr" />');

            return;
        }else{
            if("" != $("#_email_").val() && null != $("#_email_").val()){

                if(FormUtil.checkEmail($("#_email_").val())){
                     Common.alert('<spring:message code="sal.alert.msg.invaildEmailAddr" />');
                     return;
                }
            }
        }

        if($("#_cmbCorpTypeId_").val() != "1333" && $("#_cmbCorpTypeId_").val() != "1151"){
            if($("#_tin_").val() == "" || $("#_tin_").val() == null){
                Common.alert("Please enter Company TIN to proceed.");
                return;
             }
        }

        if($('input:checkbox[id="isEInvoice"]').is(":checked") == true && $("#_tin_").val() == ''){
            Common.alert('Please fill in TIN to receive e-Invoice.');
            return false;
        }


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
        //$("#_asTelF_").val($("#_telF_").val());
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

    function fn_addBankAccountInfo(accType,accBank,accNo,bankBranch,accOwner,accRem){

        var accItem = new Object();

        if(accType != "" && accBank != "" && accNo != "" && accOwner != ""){
            accItem.accTypeId = accType;
            accItem.accBankId = accBank;
            accItem.accNo = accNo;
            accItem.bankBranch = bankBranch;
            accItem.accOwner = accOwner;
            accItem.accRem = accRem;
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

    function emailCheck(){
        if($("#_email_").val() == ""){
            return
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
                AUIGrid.resize(myGridID, 960, 380);
                break;
            case 'account' :
                AUIGrid.resize(myGridID1, 960, 380);
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

        /* if($("#_cmbTypeId_").val() != '964'){
            return;
        } */


        console.log("_cmbTypeId_ ::" + $("#_cmbTypeId_").val());

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
        }, function(jqXHR, textStatus, errorThrown) {
            Common.alert("실패하였습니다.");
            console.log("실패하였습니다.");
            console.log("error : " + jqXHR + " \n " + textStatus + "\n" + errorThrown);

            alert(jqXHR.responseJSON.message);
            console.log("jqXHR.responseJSON.message" + jqXHR.responseJSON.message);

        });

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
            $("#_cmbTypeId_").val('');
            return;
        }

        /* if(inputVal.length == 12){
        	 $("#_cmbTypeId_").val('964');
        	 return;
        } */

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

</script>

<div id="popup_wrap"  ><!-- popup_wrap start -->
    <header class="pop_header"><!-- pop_header start -->
        <h1><spring:message code="sal.title.text.newCustomer2" /></h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a id="_insCloseBtn" onclick="fn_winClose2()"><spring:message code="sal.btn.close" /></a></p></li>
        </ul>
    </header>
    <!-- pop_header end -->
    <section class="pop_body">
    <!-- pop_body start -->

        <ul class="right_btns">
            <%-- <li><span class="red_text"><spring:message code="sal.title.text.compulsoryField" /></span> <span class="brown_text">#Compulsory Field(For Indvidual Type)</span></li> --%>
            <li><span class="red_text"><spring:message code="sal.title.text.compulsoryField" /></span><span class="brown_text">#Compulsory Field</span></li>
        </ul>

        <section class="tap_wrap mt20">
            <!-- tap_wrap start -->
            <ul class="tap_type1">
                <li><a href="#" class="on"><spring:message code="sal.tap.title.basicInfo" /></a></li>
                <%-- <li><a href="#"><spring:message code="sal.text.insAddr" /></a></li> --%>
                <li><a href="#" id="_contactTab"><spring:message code="sal.title.text.additialServiceContact" /></a></li>
                <%-- <li><a href="#" onclick="javascript:chgTab('card');"><spring:message code="sal.title.text.bankCard" /></a></li> --%>
                <%-- <li><a href="#" onclick="javascript:chgTab('account');"><spring:message code="sal.title.text.bankAccount" /></a></li> --%>
            </ul>
            <!-- dup Nric Check  -->
            <article class="tap_area">
                <!-- tap_area start -->
                <form id="insBasicForm" name="insBasicForm" method="POST">
                    <table class="type1">
                        <!-- table start -->
                        <caption>table</caption>
                        <colgroup>
                            <col style="width: 40%" />
                            <col style="width: *" />
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row"><spring:message code="sal.text.custType2" /><span class="must">*</span></th>
                                <td>
                                      <select class="w100p"  id="_cmbTypeId_" name="cmbTypeId" onchange="onChangeCompanyType(this.value)">
                                      <!-- <select name="cmbTypeId" id="cmbTypeId" > -->
                                        <option value="">Please Choose a Customer Type</option>
                                        <option value="965">Company</option>
                                        <option value="964">Individual</option>
                                      <select class="w100p disabled" id="_cmbTypeId_" name="cmbTypeId" disabled="disabled"></select>
                                    <!-- <div id="custTypeForm">
                                         <label><input type="radio" name="cmbTypeId" value="965" disabled="disabled" /><span>Company</span></label>
                                        <label><input type="radio" name="cmbTypeId" value="964" disabled="disabled" checked/><span>Individual</span></label>
                                         <label><input type="radio" id="custCom" name="cmbTypeId" value="965" onclick="fn_radioButton(965)" checked/><span>Company</span></label>
                                        <label><input type="radio" id="custInd" name="cmbTypeId" value="964" onclick="fn_radioButton(964)" /><span>Individual</span></label>
                                                    <input id="_cmbTypeId_" name="cmbTypeId" type="hidden"/>
                                    </div> -->
                                </td>
                            </tr>
                            <tr>
                                <th scope="row"><spring:message code="sal.text.initial2"/><span class="must">*</span></th>
                                <td><select class="w100p" id="_cmbInitials_" name="cmbInitials"></select></td>
                            </tr>
                            <tr>
                                <th scope="row"><spring:message code="sal.title.text.companyType2" /></th>
                                <td id="corpTypeForm"><select class="w100p disabled" id="_cmbCorpTypeId_" name="cmbCorpTypeId" onchange="onChangeCorpType(this.value)" disabled="disabled"></select></td>
                            </tr>
                            <tr>
                                <th scope="row"><spring:message code="sal.text.custName2" /><span class="must">*</span></th>
                                <td><input type="text" title="" id="_custName_" name="custName" placeholder="Customer Name" class="w100p" /></td>
                            </tr>
                            <tr>
                                <th scope="row"><spring:message code="sal.title.text.nricCompNo" /><span class="must">*</span></th>
                                <td><input type="text" title="" id="_nric_" name="nric" maxlength="18" placeholder="NRIC/Company No" class="w100p" onblur="javascript: fn_nricChkAndSuggDob(this.value)" /></td>
                                <!-- <th scope="row"><spring:message code="sal.text.gstRegistrationNo" /></th>
            <td>
                <input type="text" title="" id="_gstRgistNo_" name="gstRgistNo" placeholder="GST Registration No" class="w100p readonly" disabled="disabled" />
            </td> -->
                            </tr>
                            <tr>
                                <th scope="row"><spring:message code="sal.title.text.oldIcarmyPolice" /></th>
                                <td><input type="text" title="" id="_oldNric_" name="oldNric" maxlength="18" placeholder="Old IC/Army/Police" class="w100p" disabled="disabled" /></td>
                            </tr>
                            <tr>
                                <th scope="row" id="tinTitle"><spring:message code="sal.title.text.tin" /></th>
                                <td><input type="text" title="" id="_tin_" name="tin" maxlength="18" placeholder="TIN" class="w100p"/></td>
                            </tr>
                            <tr>
                                <th scope="row"><spring:message code="sal.title.text.sstRegistrationNo" /></th>
                                <td><input type="text" title="" id="_sstRgistNo_" name="sstRgistNo" maxlength="18" placeholder="SST Registration No" class="w100p" /></td>
                            </tr>
                            <tr>
                                <th scope="row"><spring:message code="sal.text.nationality2" /><span class="must foreigner">*</span>
                                <td><select class="w100p disabled" id="_cmbNation_" name="cmbNation" onchange="onChangeNation(this.value)" disabled="disabled"></select></td>
                            </tr>
                            <tr>
                                <th scope="row"><spring:message code="sal.text.passportExpire" /><span class="must foreigner">*</span></th>
                                <td><input type="text" title="Create start Date" id="_pasSportExpr_" name="pasSportExpr" placeholder="DD/MM/YYYY" class="j_date"  disabled="disabled" /></td>
                            </tr>
                            <tr>
                                <th scope="row"><spring:message code="sal.text.visaExpire" /><span class="must foreigner">*</span></th>
                                <td><input type="text" id="_visaExpr_" name="visaExpr" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date"  disabled="disabled" /></td>
                            </tr>
                            <tr>
                                <th scope="row"><spring:message code="sal.text.dob2" /><span class="foreignerMust">*</span></th>
                                <td><input type="text" id="_dob_" name="dob" title="Create start Date" placeholder="Date Of Birth" class="j_date3 w100p" disabled="disabled" /></td>
                            </tr>
                            <tr>
                                <th scope="row"><spring:message code="sal.text.gender2" /></th>
                                <td>
                                    <div id="genderForm">
                                        <label><input type="radio" name="gender" value="M" disabled="disabled" /><span><spring:message code="sal.title.text.male" /></span></label>
                                        <label><input type="radio" name="gender" value="F" disabled="disabled" /><span><spring:message code="sal.title.text.female" /></span></label>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row"><spring:message code="sal.title.text.email2" /><span class="must">*</span></th>
                                <td><input type="text" id="_email_" name="email" title="" onBlur="javascript:emailCheck()" placeholder="Email" class="w100p" /></td>
                            </tr>
                            <tr>
                                <th scope="row"><spring:message code="sal.text.race2" /><span class="must">*</span></th>
                                <td>
                                    <!-- <select class="w100p disabled" id="_cmbRace_" name="cmbRace" disabled="disabled"></select> -->
                                    <label><input type="radio" name="cmbRace" value="10" /><span>Malay</span></label>
                                    <label><input type="radio" name="cmbRace" value="11" /><span>Chinese</span></label>
                                    <label><input type="radio" name="cmbRace" value="12" /><span>Indian</span></label>
                                    <label><input type="radio" name="cmbRace" value="14" /><span>Korean</span></label>
                                    <label><input type="radio" name="cmbRace" value="13" /><span>Other</span></label>
                                                <input id="_cmbRace_" name="cmbRace" type="hidden"/>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row"><spring:message code="sal.title.text.telMOne" /><span class="must">*</span></th>
                                <td><input type="text" id="_telM1_" name="telM1" maxlength="11" title="" placeholder="Telephone Number (Mobile)" class="w100p" onblur="javascript: fn_validHPCodyContactNumber(this.value,this.id);"/></td>
                            </tr>
                            <tr>
                                <th scope="row"><spring:message code="sal.title.text.telROne" /></th>
                                <td><input type="text" id="_telR_" name="telR" maxlength="11" title="" placeholder="Telephone Number (Residence)" class="w100p" onblur="javascript: fn_validHPCodyContactNumber(this.value,this.id);"/></td>
                                <%-- <th scope="row"><spring:message code="sal.title.text.telFOne" /><span class="must">*</span></th>
            <td>
            <input type="text" id="_telF_" name="telF" maxlength="11" title="" placeholder="Telephone Number (Fax)" class="w100p" />
            </td> --%>
                            </tr>
                            <tr>
                                <th scope="row"><spring:message code="sal.title.text.telOOne" /></th>
                                <td><input type="text" id="_telO_" name="telO" maxlength="11" title="" placeholder="Telephone Number (Office)" class="w100p" onblur="javascript: fn_validHPCodyContactNumber(this.value,this.id);"/></td>
                            </tr>
                            <tr>
                                <th scope="row"><spring:message code="sal.title.text.extNo" /></th>
                                <td><input type="text" id="_ext_" name="ext" title="" placeholder="Extension Number" class="w100p" /></td>
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
                            </tr>
                            <tr>
                                <th scope="row"><spring:message code="sal.text.eInvoicFlag" /></th>
						        <td><input id="isEInvoice" name="isEInvoice" type="checkbox" /></td>
							</tr>
                            <tr>
                                <td colspan=2><span class="red_text">No Contain ' - ' in contact numbers</span></td>
                            </tr>
                            <%-- <tr>
            <th scope="row"><spring:message code="sal.title.remark" /></th>
            <td colspan="3">
            <textarea cols="20" rows="5" id="_rem_" name="rem" placeholder="Remark"></textarea>
            </td>
        </tr> --%>
                        </tbody>
                    </table>
                    <!-- table end -->
                </form>

                <ul class="center_btns">
                    <li><p class="btn_blue2 big"><a href="#" onclick="fn_saveConfirm()" class="_custMakeBtn"><spring:message code="sal.btn.save" /></a></p></li>
                </ul>


            </article>
            <!-- tap_area end -->

            <article class="tap_area">
                <!-- tap_area start -->

                <aside class="title_line">
                    <!-- title_line start -->
                    <h2>
                        <spring:message code="sal.text.contactPerson" />
                    </h2>
                    <ul class="right_opt">
                        <li><p class="btn_blue2"><a href="#" onclick="fn_copyCustInfo()"><spring:message code="sal.title.text.copyFromCustInfo" /></a></p></li>
                    </ul>
                </aside>
                <!-- title_line end -->

                <form id="insContactForm" name="insContactForm" method="POST">
                    <table class="type1">
                        <!-- table start -->
                        <caption>table</caption>
                        <colgroup>
                            <col style="width: 40%" />
                            <col style="width: *" />
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row"><spring:message code="sal.text.name" /><span class="must">*</span></th>
                                <td colspan="1"><input type="text" id="_asCustName_" name="asCustName" title="" placeholder="Name" class="w100p" /></td>
                            </tr>
                            <tr>
                                <th scope="row"><spring:message code="sal.title.text.telMTwo" /><span class="must">*</span></th>
                                <td><input type="text" id="_asTelM_" name="asTelM" maxlength="11" title="" placeholder="Telephone Number (Mobile)" class="w100p" onblur="javascript: fn_validHPCodyContactNumber(this.value,this.id);"/></td>
                            </tr>
                            <tr>
                                <th scope="row"><spring:message code="sal.title.text.telRTwo" /></th>
                                <td><input type="text" id="_asTelR_" name="asTelR" maxlength="11" title="" placeholder="Telephone Number (Residence)" class="w100p" onblur="javascript: fn_validHPCodyContactNumber(this.value,this.id);"/></td>
                            </tr>
                            <tr>
                                <th scope="row"><spring:message code="sal.title.text.telOTwo" /></th>
                                <td><input type="text" id="_asTelO_" name="asTelO" maxlength="11" title="" placeholder="Telephone Number (Office)" class="w100p" onblur="javascript: fn_validHPCodyContactNumber(this.value,this.id);"/></td>
                            </tr>
                            <tr>
                                <th scope="row"><spring:message code="sal.title.text.ext" /></th>
                                <td><input type="text" id="_asExt_" name="asExt" title="" placeholder="Extension Number" class="w100p" /></td>
                            </tr>
                            <tr>
                                <%-- <th scope="row"><spring:message code="sal.title.text.telFTwo" /><span class="must">*</span></th>
                                        <td><input type="text" id="_asTelF_" name="asTelF" title="" placeholder="Telephone Number (Fax)" class="w100p" /></td> --%>
                                <th scope="row"><spring:message code="sal.title.text.emailTwo" /></th>
                                <td><input type="text" id="_asEmail_" name="asEmail" title="" onBlur="javascript:asEmailCheck()" placeholder="Email" class="w100p" /></td>
                            </tr>
                        </tbody>
                    </table>
                    <!-- table end -->
                </form>
                <ul class="center_btns">
                    <li><p class="btn_blue2 big">
                            <a href="#" onclick="fn_saveConfirm()" class="_custMakeBtn"><spring:message code="sal.btn.save" /></a>
                        </p></li>
                </ul>

            </article>
            <!-- tap_area end -->


            <article class="tap_area">
                <!-- tap_area start -->

                <aside class="title_line">
                    <!-- title_line start -->
                    <h2>
                        <spring:message code="sal.text.instAddr" />
                    </h2>
                </aside>
                <!-- title_line end -->

                <form id="insAddressForm" name="insAddressForm" method="POST">
                    <input type="hidden" id="areaId" name="areaId">
                    <table class="type1">
                        <!-- table start -->
                        <caption>table</caption>
                        <colgroup>
                            <col style="width: 40%" />
                            <col style="width: *" />
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row"><spring:message code="sal.title.text.areaSearch2" /><span class="must">*</span></th>
                                <td colspan="1"><input type="text" title="" id="_searchSt_" name="searchSt" placeholder="eg. TAMAN RIMBA" class="" />
                                    <a href="#" onclick="fn_addrSearch()" class="search_btn">
                                        <img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" />
                                    </a>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row"><spring:message code="sal.text.addressDetail2" /><span class="must">*</span></th>
                                <td colspan="1"><input type="text" title="" id="_addrDtl_" name="addrDtl" placeholder="eg. NO 10/UNIT 13-02-05/LOT 33945" class="w100p" /></td>
                            </tr>
                            <tr>
                                <th scope="row"><spring:message code="sal.text.street2" /></th>
                                <td colspan="1"><input type="text" title="" id="_streetDtl_" name="streetDtl" placeholder="eg. TAMAN/JALAN/KAMPUNG" class="w100p" /></td>
                            </tr>
                            <tr>
                                <th scope="row"><spring:message code="sal.text.area42" /><span class="must">*</span></th>
                                <td colspan="1"><select class="w100p" id="_mArea_" name="mArea" onchange="javascript : fn_getAreaId()"></select></td>
                            </tr>
                            <tr>
                                <th scope="row"><spring:message code="sal.text.postCode32" /><span class="must">*</span></th>
                                <td><select class="w100p" id="_mPostCd_" name="mPostCd" onchange="javascript : fn_selectPostCode(this.value)"></select></td>
                            </tr>
                            <tr>
                                <th scope="row"><spring:message code="sal.text.city22" /><span class="must">*</span></th>
                                <td><select class="w100p" id="_mCity_" name="mCity" onchange="javascript : fn_selectCity(this.value)"></select></td>
                            </tr>
                            <tr>
                                <th scope="row"><spring:message code="sal.text.state12" /><span class="must">*</span></th>
                                <td><select class="w100p" id="_mState_" name="mState" onchange="javascript : fn_selectState(this.value)"></select></td>
                            </tr>
                            <tr>
                                <th scope="row"><spring:message code="sal.text.country2" /><span class="must">*</span></th>
                                <td><input type="text" title="" id="_mCountry_" name="mCountry" placeholder="" class="w100p readonly" readonly="readonly" value="Malaysia" /></td>
                            </tr>
                            <tr>
                                    <th scope="row"><spring:message code="sal.text.remarks" /></th>
                                    <td colspan="3"><textarea cols="20" rows="5" id="_addrRem_" name="addrRem" placeholder="Remark"></textarea></td>
                            </tr>
                        </tbody>
                    </table>
                    <!-- table end -->
                </form>
                <ul class="center_btns">
                    <li><p class="btn_blue2 big"><a href="#" onclick="fn_saveConfirm()" class="_custMakeBtn"><spring:message code="sal.btn.save2" /></a></p></li>
                </ul>

            </article>
            <!-- tap_area end -->

            <article class="tap_area">
                <!-- tap_area start -->
                <ul class="right_btns">
                    <li><p class="btn_grid">
                            <a href="#" onclick="fn_addCreditCardPop()"><spring:message code="sal.title.text.addCrdCard" /></a>
                        </p></li>
                </ul>

                <article class="grid_wrap">
                    <!-- grid_wrap start -->
                    <div id="card_grid" style="width: 100%; height: 380px; margin: 0 auto;"></div>
                </article>
                <!-- grid_wrap end -->

                <ul class="center_btns">
                    <li><p class="btn_blue2 big">
                            <a href="#" onclick="fn_saveConfirm()" class="_custMakeBtn"><spring:message code="sal.btn.save" /></a>
                        </p></li>
                </ul>
            </article>
            <!-- tap_area end -->

            <article class="tap_area">
                <!-- tap_area start -->
                <ul class="right_btns">
                    <li><p class="btn_grid">
                            <a href="#" onclick="fn_addBankAccountPop()"><spring:message code="sal.title.addBankAccount" /></a>
                        </p></li>
                </ul>

                <article class="grid_wrap">
                    <!-- grid_wrap start -->
                    <div id="account_grid" style="width: 100%; height: 380px; margin: 0 auto;"></div>
                </article>
                <!-- grid_wrap end -->

                <ul class="center_btns">
                    <li><p class="btn_blue2 big">
                            <a href="#" onclick="fn_saveConfirm()" class="_custMakeBtn"><spring:message code="sal.btn.save" /></a>
                        </p></li>
                </ul>

            </article><!-- tap_area end -->

        </section><!-- tap_wrap end -->
    </section><!-- pop_body end -->
</div>