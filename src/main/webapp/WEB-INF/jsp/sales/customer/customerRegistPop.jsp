<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
	
	//AUIGrid 그리드 객체
	var myGridID;          // credit card
	var myGridID1;        // bank account
	
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
        
        // AUIGrid 그리드를 생성합니다.
        createAUIGrid();
        
        AUIGrid.setSelectionMode(myGridID, "singleRow");
        
        // 셀 더블클릭 이벤트 바인딩
        
        // 셀 클릭 이벤트 바인딩
    
    });
 
    function createAUIGrid() {
    	// AUIGrid 칼럼 설정
    	// credit card
        var columnLayout = [ 
            {         
                dataField : "cardType",
                headerText : "Card Type",
                width : 100,
                editable : true
            },{
                dataField : "crcType",
                headerText : "Crc Type",
                width : 100,
                editable : true
            },{
                dataField : "bank",
                headerText : "Bank",
                width : 100,
                editable : true
            }, {
                dataField : "nmCard",
                headerText : "Name",
                editable : true
            }, {
                dataField : "creditCardNo",
                headerText : "Credit Card No",
                width : 100,
                editable : true
            }, {
                dataField : "cardExpiry",
                headerText : "Expiry",
                editable : true
            }, {
                dataField : "cardRem",
                headerText : "Remark",
                editable : true
            }];
    	
    	// bank account
        var columnLayout1 = [ 
            {         
                dataField : "accType",
                headerText : "Type",
                width : 100,
                editable : true
            },{
                dataField : "accBank",
                headerText : "Bank",
                width : 100,
                editable : true
            },{
                dataField : "accOwner",
                headerText : "Name",
                width : 100,
                editable : true
            }, {
                dataField : "accNo",
                headerText : "Account No",
                editable : true
            }, {
                dataField : "bankBranch",
                headerText : "Bank Branch",
                width : 100,
                editable : true
            }, {
                dataField : "accRem",
                headerText : "Remark",
                editable : true
            }];

        //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
        myGridID = AUIGrid.create("#card_grid", columnLayout, "");
        myGridID1 = AUIGrid.create("#account_grid", columnLayout1, "");
        
        // 그리드 최초에 빈 데이터 넣음.
        AUIGrid.setGridData(myGridID, []);
        AUIGrid.setGridData(myGridID1, []);
    }
	
	    
	//f_multiCombo 함수 호출이 되어야만 multi combo 화면이 안깨짐.
	doGetCombo('/common/selectCodeList.do', '8', '','cmbTypeId', 'S' , '');                              // Customer Type Combo Box
	doGetComboAddr('/common/selectAddrSelCodeList.do', 'country' , '' , '','cmbNation', 'A', '');  // Nationality Combo Box
	doGetCombo('/common/selectCodeList.do', '95', '','cmbCorpTypeId', 'S' , '');                      // Company Type Combo Box 
	doGetCombo('/common/selectCodeList.do', '17', '','cmbInitials', 'S' , '');                             // Initials Combo Box
	doGetCombo('/common/selectCodeList.do', '2', '','cmbRace', 'S' , '');                                 // Race Combo Box
//	doGetComboAddr('/common/selectAddrSelCodeList.do', 'state' , '' , '','cmbState', 'A', '');      // State Combo Box (installation Address)
    doGetCombo('/common/selectCodeList.do', '20', '','cmbBankType', 'S' , '');                         // Add Bank Type Combo Box
	getAddrRelay('mstate' , '1' , 'state', '');
	// 조회조건 combo box
//    function f_multiCombo(){
//        $(function() {
//            $('#cmbTypeId').change(function() {
//            
//            }).multipleSelect({
//                selectAll: true, // 전체선택 
//                width: '80%'
//            });
//            $('#cmbCorpTypeId').change(function() {
//                
//            }).multipleSelect({
//                selectAll: true, // 전체선택 
//                width: '80%'
//            });
//           
//       });
//    }
	
	// Customer Type 선택시 Company Type 변경 (Basic Info)
	function onChangeCompanyType(val){

		if($("#cmbTypeId").val() == '965'){
			$("select[name=cmbCorpTypeId]").removeAttr("disabled");
			$("select[name=cmbCorpTypeId]").removeClass("w100p disabled");
			$("select[name=cmbCorpTypeId]").addClass("w100p");
			$("#cmbCorpTypeId").val('1173');
			$("#cmbNation").val('');
			$("select[name=cmbNation]").addClass("w100p disabled");
            $("select[name=cmbNation]").attr('disabled', 'disabled');
            $("#cmbRace").val('');
            $("select[name=cmbRace]").addClass("w100p disabled");
            $("select[name=cmbRace]").attr('disabled', 'disabled');
            $("#dob").val('');
            $("#dob").addClass("j_date readonly");
//            $("select[name=dob]").attr('readonly','readonly');
            $("#dob").attr('disabled', 'disabled');
            $("#genderForm").attr('disabled',true);
            $("input:radio[name='gender']:radio[value='M']").prop("checked", false);
            $("input:radio[name='gender']:radio[value='F']").prop("checked", false);
            $("#genderForm").attr('checked', false);
		}else{
			$("#cmbCorpTypeId").val('');
			$("select[name=cmbCorpTypeId]").attr('disabled', 'disabled');
			$("select[name=cmbCorpTypeId]").addClass("w100p disabled");
			$("select[name=cmbNation]").removeClass("w100p disabled");
			$("select[name=cmbNation]").addClass("w100p");
			$("select[name=cmbNation]").removeAttr("disabled");
			$("select[name=cmbRace]").removeClass("w100p disabled");
			$("select[name=cmbRace]").addClass("w100p");
            $("select[name=cmbRace]").removeAttr("disabled");
            $("#dob").removeClass("j_date readonly");
            $("#dob").addClass("j_date");
//            $("select[name=dob]").removeAttr("readonly");
            $("#dob").removeAttr("disabled");
            $("#genderForm").removeAttr('disabled');
		}
		
	}
	
	function fn_addCreditCard(){
        Common.popupWin("insBasicForm", "/sales/customer/customerAddCreditCardPop.do", option);
    }
	
	function fn_addBankAccount(){
        Common.popupWin("insBasicForm", "/sales/customer/customerAddBankAccountPop.do", option);
    }
    
	
	// save confirm
	function fn_saveConfirm(){
		if(fn_saveValidationCheck()){
            Common.confirm("<spring:message code='sys.common.alert.save'/>", fn_saveNewCustomer);
		}
	}
	
	// save
	function fn_saveNewCustomer(){

			var customerForm = {
	            dataSet     : GridCommon.getEditData(myGridID),
	            dataSetBank     : GridCommon.getEditData(myGridID1),
	            customerVO : {
	            	cmbTypeId : insBasicForm.cmbTypeId.value,
	            	custName : insBasicForm.custName.value,
	            	cmbCorpTypeId : insBasicForm.cmbCorpTypeId.value,
	            	custInitial : insBasicForm.cmbInitials.value,
	            	nric : insBasicForm.nric.value,
	            	gstRgistNo : insBasicForm.gstRgistNo.value,
	            	cmbNation : insBasicForm.cmbNation.value,
	            	pasSportExpr : insBasicForm.pasSportExpr.value,
	            	dob : insBasicForm.dob.value,
	            	visaExpr : insBasicForm.visaExpr.value,
	            	gender : insBasicForm.gender.value,
	            	email : insBasicForm.email.value,
	            	cmbRace : insBasicForm.cmbRace.value,
	            	telM1 : insBasicForm.telM1.value,
	            	telR : insBasicForm.telR.value,
	            	telF : insBasicForm.telF.value,
	            	telO : insBasicForm.telO.value,
	            	ext : insBasicForm.ext.value,
	            	rem : insBasicForm.rem.value,
	            	addr1 : insAddressForm.mAddr1.value,
	            	addr2 : insAddressForm.mAddr2.value,
	            	streetId : insAddressForm.streetId.value,
	            	asCustName : insContactForm.asCustName.value,
	            	asTelM : insContactForm.asTelM.value,
	            	asTelO : insContactForm.asTelO.value,
	            	asTelR : insContactForm.asTelR.value,
	            	asTelF : insContactForm.asTelF.value,
	            	asExt : insContactForm.asExt.value,
	            	asEmail : insContactForm.asEmail.value	            	
	            }
	        };
			
			Common.ajax("POST", "/sales/customer/insCustBasicInfo.do", customerForm, function(result) {
				Common.alert(result.message);

			}, function(jqXHR, textStatus, errorThrown) {
                Common.alert("실패하였습니다.");
                console.log("실패하였습니다.");
                console.log("error : " + jqXHR + " \n " + textStatus + "\n" + errorThrown);
                
                alert(jqXHR.responseJSON.message);
                console.log("jqXHR.responseJSON.message" + jqXHR.responseJSON.message);
				
			});
		
	}
	
	// Validation Check
	function fn_saveValidationCheck(){
		if($("#cmbTypeId").val() == ''){
			Common.alert("Please select costomer type");
			return false;
		}
		if($("#nric").val() == ''){
			Common.alert("Please key in NRIC/Company number");
            return false;
        }else{
        	if(FormUtil.checkNum($("#nric"))){
                Common.alert("* Invalid nric number.");
                return;
            }
        }
		if($("#custName").val() == ''){
			Common.alert("Please key in customer name");
            return false;
        }
		if($("#telM1").val() == '' && $("#telR").val() == '' && $("#telF").val() == '' && $("#telO").val() == '' ){
			Common.alert("Please key in at least one contact number");
            return false;
        }else{
        	if($("#telM1").val() != ''){
        		if(FormUtil.checkNum($("#telM1"))){
        			Common.alert("* Invalid telephone number (Mobile).");
                    return false;
                }
                if($("#telM1").length > 20){
                	Common.alert("* Telephone number (Mobile) exceed length of 20.");
                    return false;
                }
        	}
        	if($("#telO").val() != ''){

                   if(FormUtil.checkNum($("#telO"))){
                	   Common.alert("* Invalid telephone number (Office).");
                       return false;
                   }
                   if($("#telO").length > 20){
                	   Common.alert("* Telephone number (Office) exceed length of 20.");
                       return false;
                   }
               }
        	if($("#telR").val() != ''){
                   if(!FormUtil.checkNum($("#telR"))){
                	   Common.alert("* Invalid telephone number (Office).");
                   }
                   if($("#telR").length > 20){
                	   Common.alert("* Telephone number (Office) exceed length of 20.");
                       return false;
                   }
               }
        	if($("#telF").val() != ''){
                   if(!FormUtil.checkNum($("#telF").val())){
                	   Common.alert("* Invalid telephone number (Office).");
                   }
                   if($("#telF").length > 20){
                	   Common.alert("* Telephone number (Office) exceed length of 20.");
                       return false;
                   }
               }
        }
		
		if($("#cmbTypeId").val() == '964'){
			if($("#cmbNation").val() == ''){
				Common.alert("* Please select nationality.");
				return false;
			}
			if($("#dob").val() == ''){
				Common.alert("* Please key in customer DOB.");
                   return false;
            }
			// Gender validation check (해야함.) * Customer is exist.
			if($("#cmbRace").val() == ''){
				Common.alert("* Please select customer race.");
                   return false;
            }
			if($("#cmbInitials").val() == ''){
				Common.alert("* Please select contact person initial.");
                   return false;
            }
		}
		
		if($("#mAddr1").val() == ''){
			Common.alert("Please key in the address.");
            return false;
        }
		if($("#mAddr2").val() == ''){
            Common.alert("Please key in the address.");
            return false;
        }
		if($("#mState").val() == ''){
			Common.alert("Please key in the state.");
            return false;
        }
		if($("#mCity").val() == ''){
			Common.alert("Please key in the city.");
            return false;
        }
		if($("#mTown").val() == ''){
            Common.alert("Please key in the town.");
            return false;
        }
		if($("#mStreet").val() == ''){
            Common.alert("Please key in the street.");
            return false;
        }
		if($("#mPostCd").val() == ''){
			Common.alert("Please key in the postcode.");
            return false;
        }
		
		if($("#asCustName").val() == ''){
			Common.alert("Please key in customer name.");
            return false;
        }
		if($("#asTelM").val() == '' && $("#asTelR").val() == '' && $("#asTelF").val() == '' && $("#asTelO").val() == '' ){
			Common.alert("Please key in at least one contact number");
            return false;
        }
		
//		if(!FormUtil.checkNum($("#ext").val())){
//               alert("* Invalid extension number.");
//        }
		return true;
	}
	
	function fn_copyCustInfo(){
		$("#asCustName").val($("#custName").val());
		$("#asTelM").val($("#telM1").val());
		$("#asTelR").val($("#telR").val());
		$("#asTelO").val($("#telO").val());
		$("#asTelF").val($("#telF").val());
		$("#asExt").val($("#ext").val());
		$("#asEmail").val($("#email").val());
	}
	
	function fn_addCreditCardInfo(ccType,iBank,cardNo,expDate,nameCard,cType,cardRem){
		
		var item = new Object();
		
		if(ccType != "" && iBank != "" && cardNo != "" && expDate != "" && nameCard != "" && cType != ""){
			item.crcType = ccType;
	        item.bank = iBank;
	        item.creditCardNo = cardNo;
	        item.cardExpiry = expDate;
	        item.nmCard = nameCard;
	        item.cardType = cType;
	        item.cardRem = cardRem;
	        AUIGrid.addRow(myGridID, item, "last"); 
		}
	}
	
    function fn_addBankAccountInfo(accType,accBank,accNo,bankBranch,accOwner,accRem){

        var accItem = new Object();
        
        if(accType != "" && accBank != "" && accNo != "" && accOwner != ""){
            accItem.accType = accType;
            accItem.accBank = accBank;
            accItem.accNo = accNo;
            accItem.bankBranch = bankBranch;
            accItem.accOwner = accOwner;
            accItem.accRem = accRem;
            AUIGrid.addRow(myGridID1, accItem, "last"); 
        }
    }
    
    function fn_addMaddr(mstate,mcity,mtown,mpostCd,mstreet,miso,mstreetId){
     
        if(mstate != "" && mcity != "" && mtown != "" && mpostCd != "" && mstreet != "" && mstreetId != ""){
            $("#mState").val(mstate);
            $("#mCity").val(mcity);
            $("#mTown").val(mtown);
            $("#mPostCd").val(mpostCd);
            $("#mStreet").val(mstreet);
            $("#mCountry").val(miso);
            $("#streetId").val(mstreetId);
            $("#_searchDiv").remove();
        }else{
        	Common.alert("Please check your address.");
        }
    }
	
//    function fn_nricDupChk(){
//    	
//    	var url = "/sales/customer/nricDupChk.do";
//    	var param = {"nric" : insBasicForm.nric.value, "cmbTypeId" : insBasicForm.cmbTypeId.value};
//    	$.ajax({
//    		url : url,
//    		type : 'POST',
 //   		data : param,
 //   		success:function(data){
 //   			alert(data.dup);
 //   		},
 //   		error: function(jqXHR, textStatus, errorThrown){
 //           },
 //           complete: function(){
 //           }
 //   	},
//    	Common.ajax("POST", url, param, function(result) {
//    		if(result.dup > 0){
//    			Common.alert("This is existing customer.");
//    		}else{
    			
//    		}
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
    	if(FormUtil.checkEmail($("#email"))){
//    		$("input[name='email']").focus();
            Common.alert("Invalid email address.");
            
            $("#email").val('');
            
            return false;
        }
    }
    
    function asEmailCheck(){
        if(FormUtil.checkEmail($("#asEmail"))){
            Common.alert("Invalid email address.");
            $("#asEmail").val('');
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
    	if($("#searchSt").val() == ''){
            Common.alert("Please search.");
            return false;
        }
    	Common.popupDiv('/sales/customer/searchMagicAddressPop.do' , $('#insAddressForm').serializeJSON(), null , true, '_searchDiv');
    }

</script>

<!-- 
	<div id="popup_wrap"><!-- popup_wrap start --
	
	<header class="pop_header"><!-- pop_header start --
	<h1>New Customer</h1>
	<ul class="right_opt">
	    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
	</ul>
	</header><!-- pop_header end --
 -->
<section class="pop_body mt20"><!-- pop_body start -->

<ul class="right_btns">
    <li><span class="red_text">*Compulsory Field</span> <span class="brown_text">#Compulsory Field(For Indvidual Type)</span></li>
</ul>

<section class="tap_wrap mt20"><!-- tap_wrap start -->
<ul class="tap_type1">
    <li><a href="#" class="on">Basic Info</a></li>
    <li><a href="#">Install Address</a></li>
    <li><a href="#">Additional Service Contact</a></li>
    <li><a href="#" onclick="javascript:chgTab('card');">Credit Card</a></li>
    <li><a href="#" onclick="javascript:chgTab('account');">Bank Account</a></li>
</ul>

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
		    <th scope="row">Customer Type<span class="must">*</span></th>
		    <td>
			    <select class="w100p"  id="cmbTypeId" name="cmbTypeId" onchange="onChangeCompanyType()">
			    </select>
		    </td>
		    <th scope="row">Company Type</th>
		    <td id="corpTypeForm">
			    <select class="w100p disabled" id="cmbCorpTypeId" name="cmbCorpTypeId" disabled="disabled">
			    </select>
		    </td>
		</tr>
		<tr>
		    <th scope="row">Initials<span class="must">*</span></th>
		    <td>
			    <select class="w100p" id="cmbInitials" name="cmbInitials"></select>
		    </td>
		    <th scope="row">Customer Name<span class="must">*</span></th>
		    <td>
		        <input type="text" title="" id="custName" name="custName" placeholder="Customer Name" class="w100p" />
		    </td>
		</tr>
		<tr>
		    <th scope="row">NRIC/Company No<span class="must">*</span></th>
		    <td>
		        <input type="text" title="" id="nric" name="nric" maxlength="12"  placeholder="NRIC/Company No" class="w100p" />
		    </td>
		    <th scope="row">GST Registration No</th>
		    <td>
		        <input type="text" title="" id="gstRgistNo" name="gstRgistNo" placeholder="GST Registration No" class="w100p readonly" disabled="disabled" />
		    </td>
		</tr>
		<tr>
		    <th scope="row">Nationality <span class="brown_text">#</span></th>
		    <td>
			    <select class="w100p disabled" id="cmbNation" name="cmbNation" disabled="disabled">
			    </select>
		    </td>
		    <th scope="row">Passport Expire</th>
		    <td>
		        <input type="text" title="Create start Date" id="pasSportExpr" name="pasSportExpr" placeholder="DD/MM/YYYY" class="j_date" />
		    </td>
		</tr>
		<tr>
		    <th scope="row">DOB <span class="brown_text">#</span></th>
		    <td>
		        <input type="text" id="dob" name="dob" title="Create start Date" placeholder="Date Of Brith" class="j_date readonly" disabled="disabled" />
		    </td>
		    <th scope="row">Visa Expire</th>
		    <td>
		        <input type="text" id="visaExpr" name="visaExpr" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" />
		    </td>
		</tr>
		<tr>
		    <th scope="row">Gender <span class="brown_text">#</span></th>
		    <td>
		        <div id="genderForm" disabled="disabled">
			    <label><input type="radio" name="gender" id="gender" value="M"/><span>Male</span></label>
			    <label><input type="radio" name="gender" id="gender" value="F"/><span>Female</span></label>
			    </div>
		    </td>
		    <th scope="row">Email(1)</th>
		    <td>
		      <input type="text" id="email" name="email" title="" onBlur="javascript:emailCheck()" placeholder="Email" class="w100p" />
		    </td>
		</tr>
		<tr>
		    <th scope="row">Race <span class="brown_text">#</span></th>
		    <td>
			    <select class="w100p disabled" id="cmbRace" name="cmbRace" disabled="disabled">
			    </select>
		    </td>
		    <th scope="row">Tel(Mobile)(1)<span class="must">*</span></th>
		    <td>
		        <input type="text" id="telM1" name="telM1" maxlength="20" title="" placeholder="Telephone Number (Mobile)" class="w100p" />
		    </td>
		</tr>
		<tr>
		    <th scope="row">Tel(Residence)(1)<span class="must">*</span></th>
		    <td>
		    <input type="text" id="telR" name="telR" maxlength="20" title="" placeholder="Telephone Number (Residence)" class="w100p" />
		    </td>
		    <th scope="row">Tel(Fax)(1)<span class="must">*</span></th>
		    <td>
		    <input type="text" id="telF" name="telF" maxlength="20" title="" placeholder="Telephone Number (Fax)" class="w100p" />
		    </td>
		</tr>
		<tr>
		    <th scope="row">Tel(Office)(1)<span class="must">*</span></th>
		    <td>
		    <input type="text" id="telO" name="telO" maxlength="20" title="" placeholder="Telephone Number (Office)" class="w100p" />
		    </td>
		    <th scope="row">Ext No.</th>
		    <td>
		    <input type="text" id="ext" name="ext" title="" placeholder="Extension Number" class="w100p" />
		    </td>
		</tr>
		<tr>
		    <th scope="row">Remark</th>
		    <td colspan="3">
		    <textarea cols="20" rows="5" id="rem" name="rem" placeholder="Remark"></textarea>
		    </td>
		</tr>
	</tbody>
	</table><!-- table end -->
</form>

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onclick="fn_saveConfirm()">SAVE</a></p></li>
</ul>


</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<aside class="title_line"><!-- title_line start -->
<h2>Installation Address</h2>
</aside><!-- title_line end -->

<form id="insAddressForm" name="insAddressForm" method="POST">
    <input type="hidden" id="streetId" name="streetId">
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
			    <th scope="row">Street search<span class="must">*</span></th>
			    <td colspan="3">
			    <input type="text" title="" id="searchSt" name="searchSt" placeholder="" class="" /><a href="#" onclick="fn_addrSearch()" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
			    </td>
			</tr>
			<tr>
			    <th scope="row" rowspan="2">Address<span class="must">*</span></th>
			    <td colspan="3">
			    <input type="text" title="" id="mAddr1" name="mAddr1" placeholder="Address(1)" class="w100p" />
			    </td>
			</tr>
			<tr>
			    <td colspan="3">
			    <input type="text" title="" id="mAddr2" name="mAddr2" placeholder="Address(2)" class="w100p" />
			    </td>
			</tr>
			<tr>
			    <th scope="row">Country<span class="must">*</span></th>
			    <td>
			    <input type="text" title="" id="mCountry" name="mCountry" placeholder="" class="w100p readonly" readonly="readonly" />
			    </td>
			    <th scope="row">Region<span class="must">*</span></th>
			    <td>
			    <input type="text" title="" id="mState" name="mState" placeholder="" class="w100p readonly" readonly="readonly" />
			    </td>
			</tr>
			<tr>
			    <th scope="row">City<span class="must">*</span></th>
			    <td>
			    <input type="text" title="" id="mCity" name="mCity" placeholder="" class="w100p readonly" readonly="readonly" />
			    </td>
			    <th scope="row">Town<span class="must">*</span></th>
			    <td>
			    <input type="text" title="" id="mTown" name="mTown" placeholder="" class="w100p readonly" readonly="readonly" />
			    </td>
			</tr>
			<tr>
			    <th scope="row">Street<span class="must">*</span></th>
			    <td>
			    <input type="text" title="" id="mStreet" name="mStreet" placeholder="" class="w100p readonly" readonly="readonly" />
			    </td>
			    <th scope="row">PostCode<span class="must">*</span></th>
			    <td>
			    <input type="text" title="" id="mPostCd" name="mPostCd" placeholder="" class="w100p readonly" readonly="readonly" />
			    </td>
			</tr>
		</tbody>
	</table><!-- table end -->
</form>
<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onclick="fn_saveConfirm()">SAVE</a></p></li>
</ul>

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<aside class="title_line"><!-- title_line start -->
<h2>Installation Address</h2>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" onclick="fn_copyCustInfo()">Copy From Customer Info</a></p></li>
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
    <th scope="row">Name<span class="must">*</span></th>
    <td colspan="3">
    <input type="text" id="asCustName" name="asCustName" title="" placeholder="Name" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row">Tel(Mobile)(2)<span class="must">*</span></th>
    <td>
    <input type="text" id="asTelM" name="asTelM" title="" placeholder="Telephone Number (Mobile)" class="w100p" />
    </td>
    <th scope="row">Tel(Residence)(2)<span class="must">*</span></th>
    <td>
    <input type="text" id="asTelR" name="asTelR" title="" placeholder="Telephone Number (Residence)" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row">Tel(Office)(2)<span class="must">*</span></th>
    <td>
    <input type="text" id="asTelO" name="asTelO" title="" placeholder="Telephone Number (Office)" class="w100p" />
    </td>
    <th scope="row">Ext</th>
    <td>
    <input type="text" id="asExt" name="asExt" title="" placeholder="Extension Number" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row">Tel(Fax)(2)<span class="must">*</span></th>
    <td>
    <input type="text" id="asTelF" name="asTelF" title="" placeholder="Telephone Number (Fax)" class="w100p" />
    </td>
    <th scope="row">Email(2)</th>
    <td>
    <input type="text" id="asEmail" name="asEmail" title="" onBlur="javascript:asEmailCheck()" placeholder="Email" class="w100p" />
    </td>
</tr>
</tbody>
</table><!-- table end -->
</form>
<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onclick="fn_saveConfirm()">SAVE</a></p></li>
</ul>

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->
<ul class="right_btns">
    <li><p class="btn_grid"><a href="#" onclick="fn_addCreditCard()">ADD CREDIT CARD</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="card_grid" style="width:100%; height:480px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onclick="fn_saveConfirm()">SAVE</a></p></li>
</ul>
</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->
<ul class="right_btns" >
    <li><p class="btn_grid"><a href="#" onclick="fn_addBankAccount()">ADD BANK ACCOUNT</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="account_grid" style="width:100%; height:480px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onclick="fn_saveConfirm()">SAVE</a></p></li>
</ul>

</article><!-- tap_area end -->

</section><!-- tap_wrap end -->

</section><!-- pop_body end -->
<!-- 
</div><!-- popup_wrap end --
-->

<!-- --------------------------------------------------------------------------------------------------------------------- -->



