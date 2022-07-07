<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<%-- <%@ include file="/WEB-INF/jsp/sales/order/convertToOrderInc.jsp"%> --%>
<%-- <%@ include file="/WEB-INF/jsp/sales/order/copyChangeOrderInc.jsp"%> --%>

<style>
.centerImg {
  display: block;
  margin-left: auto;
  margin-right: auto;
/*   width: 50%; */
}

.marginImg {
  margin-left: 20px;
  margin-bottom: 20px;
/*   width: 50%; */
}

</style>

<script type="text/javaScript" language="javascript">
	var ItmOption = {
		type : "S",
		isCheckAll : false
	};

	  //Combo Box Choose Message
    var optionState = {chooseMessage: " 1.States "};
    var optionCity = {chooseMessage: "2. City"};
    var optionPostCode = {chooseMessage: "3. Post Code"};
    var optionArea = {chooseMessage: "4. Area"};

    //파일 저장 캐시
    var myFileCaches = {};

     $(document).ready(function() {

    	 $("#contactName").val("${userFullName}".trim());
    	 $("#cartGrpId").val("${cartGrpId}".trim());
    	 $("#scnFromLocId").attr("class", "w100p disabled");
    	 $('#scnFromLocId').attr('disabled','disabled');

    	 createAUIDGridCart();

    	 setInputFile();

//     	 showImage();

         //Filed Init
         fn_initAddress();
         CommonCombo.make('mState', "/sales/customer/selectMagicAddressComboList", '' , '', optionState);

         var selVal = '${branchId}';
         CommonCombo.make('scnFromLocId', "/sales/pos/selectWhSOBrnchList", '' ,selVal, '');

         //SellingTypeComboBox
         var sellingTypePopParam = {groupCode : 507, codeIn :[6796,6797]};
         CommonCombo.make('sellingType', "/sales/pos/selectPosModuleCodeList", sellingTypePopParam , '', ItmOption);

        /* #### Btn Action  #### */
         $("#_saveBtn").click(function() {

             /* addr1 addr2 null check */
             if( ( "" == $("#addrDtl").val() || null == $("#addrDtl").val())){
                 Common.alert('<spring:message code="sal.alert.msg.plzKeyinAddr" />');
                 return;
             }

             if($("#mState").val() == ''){
                 Common.alert('<spring:message code="sal.alert.msg.plzKeyinState" />');
                 return;
             }
             if($("#mCity").val() == ''){
                 Common.alert('<spring:message code="sal.alert.msg.plzKeyinCity" />');
                 return ;
             }

             if($("#searchSt").val() ==''){
                 Common.alert("Please key in Area search(3). Area search(3) cannot be null.");
                 return ;
             }


             if($("#mTown").val() == ''){
                  Common.alert('<spring:message code="sal.alert.msg.plzKeyinTown" />');
                  return ;
             }
             if($("#mStreet").val() == ''){
                  Common.alert('<spring:message code="sal.alert.msg.plzKeyinStreet" />');
                  return ;
             }
             if($("#mPostCd").val() == ''){
                  Common.alert('<spring:message code="sal.alert.msg.plzKeyinPostcode" />');
                  return ;
             }

             if($("#areaId").val() == ''){
                 Common.alert('Area not found. <br/> Please check with System Administrator.');
                 return ;
             }

             console.log($("#insAddressForm").serializeJSON());
             fn_customerAddressInfoAddAjax();

         }) ;

         $("#_copyBtn").click(function() {

             //custAddrId
             var addid = $("#tempAddrId").val();
             $("#areaId").val($("#tempAreaId").val());

             $.ajax({
                 type : "GET",
                 url : getContextPath() + "/sales/customer/selectCustomerCopyAddressJson",
                 data : { getparam : addid},
                 dataType: "json",
                 contentType : "application/json;charset=UTF-8",
                 success : function(data) {
                        $("#mAddr1").val(data.add1);
                        $("#mAddr2").val(data.add2);
                        $("#mCountry").val(data.country);
                        $("#mState").val(data.region1);
                        $("#mCity").val(data.region2);
                        $("#mTown").val(data.locality);
                        $("#mStreet").val(data.street);
                        $("#mPostCd").val(data.postCode);
                        $("#addrRem").val(data.rem);

                 },
                 error: function(){
                    alert("Get Address Detail was Failed!");
                 },
                 complete: function(){
                 }

             });
        });


        //Enter Event
        $('#searchSt').keydown(function (event) {
            if (event.which === 13) {    //enter
                fn_addrSearch();
            }
        });

        $("#addrDtl").bind("keyup", function(){$(this).val($(this).val().toUpperCase());});
        $("#streetDtl").bind("keyup", function(){$(this).val($(this).val().toUpperCase());});

        // 20190925 KR-OHK Moblie Popup Setting
        Common.setMobilePopup(false, false, '');

    });//Document Ready Func End


        /*####### Magic Address #########*/
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

                 //$("#mPostCd").attr({"disabled" : false  , "class" : "w100p"});
                 $('#mPostCd').append($('<option>', { value: '', text: '3. Post Code' }));
                 $('#mPostCd').val('');
                 $("#mPostCd").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});

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


    // Call Ajax - DB Insert
    function fn_customerAddressInfoAddAjax(){
        Common.ajax("GET", "/sales/customer/insertCustomerAddressInfoAf.do",$("#eshopForm").serialize(), function(result) {

            if( null != $("#_callParam").val() && "" != $("#_callParam").val()){
                Common.alert(result.message);
            }else{
                Common.alert(result.message, fn_parentReload);
            }
            if('${callParam}' == 'ORD_REGISTER_BILL_MTH') {
                fn_loadMailAddr(result.data);
                $("#_close1").click();
            }
            if('${callParam}' == 'PRE_ORD_BILL_ADD') {
                fn_loadBillAddr(result.data);
                $("#_close1").click();
            }
            if('${callParam}' == 'ORD_REGISTER_INST_ADD') {
                fn_loadInstallAddr(result.data);
                $("#_close1").click();
            }
            if('${callParam}' == 'PRE_ORD_INST_ADD'){
                fn_loadInstallAddr(result.data);
                fn_loadBillAddr(result.data);
                $("#_close1").click();
            }
            if('${callParam}' == 'ORD_MODIFY_MAIL_ADR2') {
                fn_loadMailAddress(result.data);
                $("#_close1").click();
            }
        });
    }


    function fn_addrSearch(){
        // null state
        if (FormUtil.isEmpty($("#mState").val())) {
            Common.alert("<spring:message code='sys.msg.necessary' arguments='State' htmlEscape='false'/>");
            return false;
        }
        // null city
        if (FormUtil.isEmpty($("#mCity").val())) {
            Common.alert("<spring:message code='sys.msg.necessary' arguments='City' htmlEscape='false'/>");
            return false;
        }
        if($("#searchSt").val() == ''){
            Common.alert("Please search.");
            return false;
        }
        Common.popupDiv('/sales/customer/searchMagicAddressPop.do' , $('#eshopForm').serializeJSON(), null , true, '_searchDiv');

       $("#mPostCd").attr({"disabled" : false  , "class" : "w100p"});

    }


    function fn_addMaddr(marea, mcity, mpostcode, mstate, areaid, miso){

        if(marea != "" && mpostcode != "" && mcity != "" && mstate != "" && areaid != "" && miso != ""){

            $("#mArea").attr({"disabled" : false  , "class" : "w100p"});
            $("#mCity").attr({"disabled" : false  , "class" : "w100p"});
            $("#mPostCd").attr({"disabled" : false  , "class" : "w100p"});
            $("#mState").attr({"disabled" : false  , "class" : "w100p"});

            var param = {areaId:areaid};
            Common.ajax("GET", "/sales/posstock/selectDefaultBranchList", param, function(result) {
            	if(result[0].brnchId !='' || result[0].brnchId !=null ){
                    $("#scnFromLocId").val(result[0].brnchId);
                    $("#esnFromLocId").val(result[0].brnchId);
                    $("#scnFromLocId").attr("class", "w100p readonly");
            	}
            	else{
            		$("#scnFromLocId").attr({"disabled" : false  , "class" : "w100p"});
            	}

            });

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

                 var param = {areaId:result.areaId};
                 Common.ajax("GET", "/sales/posstock/selectDefaultBranchList", param, function(result) {
                     if(result[0].brnchId !='' || result[0].brnchId !=null ){
                         $("#scnFromLocId").val(result[0].brnchId);
                         $("#esnFromLocId").val(result[0].brnchId);
                         $("#scnFromLocId").attr("class", "w100p readonly");
                     }
                     else{
                         $("#scnFromLocId").attr({"disabled" : false  , "class" : "w100p"});
                     }

                 });

            });

        }

    }

    function fn_addToCart(){

    	var isVal = true;

        //Validation
        isVal = fn_addCartValidationCheck();

        if(isVal == false){
            return;
        }else{

        	  var param = {grpId: "${cartGrpId}".trim()};

                  Common.ajax("GET", "/sales/posstock/checkDiffWarehouse", param, function(result) {

                      if(result.length == 0){
                         Common.ajax("POST", "/sales/posstock/insertItemToCart.do", $("#eshopForm").serializeJSON(), function(result) {
                          Common.alert('Success to add to cart');
                          createAUIDGridCart();
                          calculateShippingFee();
                      }, function(jqXHR, textStatus, errorThrown) {
                          try {
                              console.log("status : " + jqXHR.status);
                              console.log("code : " + jqXHR.responseJSON.code);
                              console.log("message : " + jqXHR.responseJSON.message);
                              console.log("detailMessage : "
                                      + jqXHR.responseJSON.detailMessage);
                          } catch (e) {
                              console.log(e);
                          }
                      });
                  }
                      else if(result.length >=1 && result[0].locId == $("#cartItemLocId").val()){
                           Common.ajax("POST", "/sales/posstock/insertItemToCart.do", $("#eshopForm").serializeJSON(), function(result) {
                               Common.alert('Success to add to cart');
                               createAUIDGridCart();
                               calculateShippingFee();

                           }, function(jqXHR, textStatus, errorThrown) {
                               try {
                                   console.log("status : " + jqXHR.status);
                                   console.log("code : " + jqXHR.responseJSON.code);
                                   console.log("message : " + jqXHR.responseJSON.message);
                                   console.log("detailMessage : "
                                           + jqXHR.responseJSON.detailMessage);
                               } catch (e) {
                                   console.log(e);
                               }
                           });
                      }
                      else{
                      Common.alert('Unable to select different SO in 1 order.');
                  }
               });
             }
    }

    function imageDtl(id, locId){

    	   var param = {imgId: id, locId: locId};

    	   Common.ajax("GET", "/sales/posstock/selectItemList2", param, function(result) {
//                console.log(result);
               var elem = document.createElement("img");
               elem.setAttribute("src", "\\resources\\WebShare"+ result[0].filepath);
               elem.setAttribute("height", "200px");
               elem.setAttribute("width", "200px");
               elem.setAttribute("class", "centerImg");

               $("#imgItem").html("");
               $("#orderQty_addToCart").val("");
               $("#totalPrice_addToCart").val("");
               document.getElementById("imgItem").appendChild(elem);

               $("#item_addToCart").val(result[0].stkCode);
               $("#size_addToCart").val(result[0].itemSize);
               $("#qty_addToCart").val(result[0].itemQty);
               $("#price_addToCart").val(result[0].totalPrice);
               $("#weight_addToCart").val(result[0].totalWeight);
               $("#qtyAvailable_addToCart").val(result[0].itemInvQty / result[0].itemQty);
               $("#cartEshopItemId").val(result[0].id);
               $("#cartItemLocId").val(result[0].locId);

               $("#table_addToCart").show();

           });
    }

    function selectCatalogList(){

    	   $("#table_addToCart").hide();
           $("#catalogImgList").html("");
		   Common.ajax("GET", "/sales/posstock/selectCatalogList", $("#eshopForm").serializeJSON(), function(result) {
			   if(result.length==0){
				   Common.alert('Please choose another Branch / Warehouse due to default SO out of stock ');
				     $("#scnFromLocId").attr({"disabled" : false  , "class" : "w100p"});
			   }
			   else
			   {
		            for(var i=0 ; i<result.length;i++){
		                   var elem = document.createElement("img");
		                   elem.setAttribute("src", "\\resources\\WebShare"+ result[i].filepath);
		                   elem.setAttribute("height", "150px");
		                   elem.setAttribute("width", "150px");
		                   elem.setAttribute("id", result[i].id);
		                   elem.setAttribute("onclick", "imageDtl(" + result[i].id + "," + result[i].locId+ ")");
		                   elem.setAttribute("class", "marginImg");

		                   document.getElementById("catalogImgList").appendChild(elem);
		               }
			   }

		   });
    }

    $(function() {

    	 $("#orderQty_addToCart").change(function(e){
                 var totalPrice = $("#orderQty_addToCart").val() *  $("#price_addToCart").val();
                 $("#totalPrice_addToCart").val(totalPrice);
    	 });

    	 $("#scnFromLocId").change(function(e){
    		 var esnFromLocId = $("#scnFromLocId").val();
    		 $("#esnFromLocId").val(esnFromLocId);
    	 });

        $("#attachmentPaySlip").change(function(evt){

        	var file = evt.target.files[0];

            if(file == null && myFileCaches[0] != null){
                delete myFileCaches[0];
            }else if(file != null){
                myFileCaches[0] = {file:file};
            }

            var msg = '';
            if(file.name.length > 30){
                msg += "*File name wording should be not more than 30 alphabet.<br>";
            }

            var fileType = file.type.split('/');
            if(fileType[0] != 'jpg' && fileType[1] != 'jpeg' && fileType[1] != 'png' && fileType[1] != 'pdf'){
                msg += "*Only allow picture format (JPG, PNG, JPEG, PDF).<br>";
            }

            if(file.size > 2000000){
                msg += "*Only allow picture with less than 2MB.<br>";
            }
            if(msg != null && msg != ''){
                myFileCaches[0].file['checkFileValid'] = false;
                Common.alert(msg);
            }
            else{
                myFileCaches[0].file['checkFileValid'] = true;
            }

        });

    });


    function createAUIDGridCart(){

            var gridProsItem = {
                    usePaging           : true,         //페이징 사용
                    pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)
                    editable            : false,
                    fixedColumnCount    : 1,
                    showStateColumn     : true,
                    displayTreeOpen     : false,
                    headerHeight        : 30,
                    useGroupingPanel    : false,        //그룹핑 패널 사용
                    skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
                    wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
                    showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력
                    showRowCheckColumn : false, //checkBox
                    softRemoveRowMode : false
            };


            var columnLayout = [
                                {dataField: "filepath",headerText :"Image", width: 120    ,height:200 , visible:true, editable : false,

                                  renderer : {
                                      type : "ImageRenderer",
//                                       imgHeight : 30,
                                      altField : null,
                                  }},
                                {dataField: "stkCode" ,headerText :"Item" , width:120 ,height:200 , visible:true, editable : true},
                                {dataField: "itemPrice" ,headerText :"Unit Price" ,width:140 ,height:200 , visible:true, editable : false, dataType : "numeric", formatString : "#,##0"},
                                {dataField: "itemQty" ,headerText :"Total Quantity (pcs)"  ,width:120 ,height:200 , visible:true, editable : false, dataType : "numeric", formatString : "#,##0.00"},
                                {dataField: "itemOrdQty" ,headerText :"Total Carton" ,width:120 ,height:200 , visible:true, editable : false, dataType : "numeric", formatString : "#,##0.00"},
                                {dataField: "itemWeight" ,headerText :"Weight (Carton)" ,width:120   ,height:200 , visible:true, editable : false},
                                {dataField: "totalPrice" ,headerText :"Total(RM)" ,width:120   ,height:200 , visible:true, editable : false},
             ];


           $("#item_grid_cart").html("");
           myGridIDItem = GridCommon.createAUIGrid("#item_grid_cart", columnLayout,'', gridProsItem);
           AUIGrid.resize(myGridIDItem , 960, 300);

           var param = {grpId: "${cartGrpId}".trim()};

           Common.ajax("GET", "/sales/posstock/selectItemCartList",param, function(result) {
                       AUIGrid.setGridData(myGridIDItem, result);
           });

           Common.ajax("GET", "/sales/posstock/selectTotalPrice",param, function(result) {
        	   if(result.length >0){
                $("#totalOrdering").val(result[0].totalPrice);
                $("#totalWeight").val(result[0].totalWeight);
                calculateShippingFee();
        	   }
           });
    }

    function fn_addCartValidationCheck(){
    	var isVal = true;
        var orderQty = $("#orderQty_addToCart").val();
        var qtyAvailable = $("#qtyAvailable_addToCart").val();

        if($("#orderQty_addToCart").val() == ''){
            Common.alert('Please fill in Ordering Quantity (Carton) ');
            return false;
        }

        if(Number(orderQty)> Number(qtyAvailable)){
            Common.alert('Cannot exceed the Quantity Available (Carton)');
            return false;
        }
    }

    function fn_saveValidationCheck(){

    	var isVal = true;

        if($("#contactNo").val() == ''){
            Common.alert('Please fill in Tel (Mobile) ');
            return false;
        }

        /* addr1 addr2 null check */
        if( ( "" == $("#addrDtl").val() || null == $("#addrDtl").val())){
            Common.alert('<spring:message code="sal.alert.msg.plzKeyinAddr" />');
            return false;
        }

        if($("#mState").val() == ''){
            Common.alert('<spring:message code="sal.alert.msg.plzKeyinState" />');
            return false;
        }
        if($("#mCity").val() == ''){
            Common.alert('<spring:message code="sal.alert.msg.plzKeyinCity" />');
            return false;
        }

        if($("#searchSt").val() ==''){
            Common.alert("Please key in Area search(3). Area search(3) cannot be null.");
            return false;
        }

        if($("#mTown").val() == ''){
             Common.alert('<spring:message code="sal.alert.msg.plzKeyinTown" />');
             return false;
        }
        if($("#mStreet").val() == ''){
             Common.alert('<spring:message code="sal.alert.msg.plzKeyinStreet" />');
             return false;
        }
        if($("#mPostCd").val() == ''){
             Common.alert('<spring:message code="sal.alert.msg.plzKeyinPostcode" />');
             return false;
        }

        if($("#areaId").val() == ''){
            Common.alert('Area not found. <br/> Please check with System Administrator.');
            return false;
        }

        if($("#attachmentPaySlip").val() == ''){
            Common.alert('Please upload payslip in Attachment');
            return false;
        }

        if($("#totalOrdering").val() == ''){
            Common.alert('Cart cannot be empty. Please add item into cart.');
            return false;
        }



    }

    function calculateGrandTotal(){
    	var totalOrdering = $("#totalOrdering").val();
    	var totalShippingFee = $("#totalShippingFee").val();
    	var grandTotal = Number(totalOrdering) + Number(totalShippingFee);
    	$("#totalPrice").val(grandTotal);
    }

    function calculateShippingFee(){
    	 var regionType;
         var mstate =$("#mState").val();
         if(mstate !="" || mstate !=null){
             if(mstate.toUpperCase().trim() =="LABUAN" || mstate.toUpperCase().trim() =="SABAH" || mstate.toUpperCase().trim() =="SARAWAK"){
                 regionType = 6803;
             }else{
                 regionType = 6804;
             }
         }

         console.log($("#totalWeight").val());
         var param = {regionType: regionType, weight:$("#totalWeight").val()};
         Common.ajax("GET", "/sales/posstock/selectShippingFee", param , function(result) {
             if(result.length > 0){
                 $("#totalShippingFee").val(result[0].totalShippingFee);
                 calculateGrandTotal();
             }
         });
    }

    // save confirm
    function fn_saveConfirm(){

        var isVal = true;

        //Validation
        isVal = fn_saveValidationCheck();

        if(isVal == false){
            return;
        }else{

        	console.log($("#eshopForm").serializeJSON());

            var formData = new FormData();
            $.each(myFileCaches, function(n, v) {
                console.log("n : " + n + " v.file : " + v.file);
                formData.append(n, v.file);
            });

            Common.ajaxFile("/sales/posstock/attachFileUpload.do", formData, function(result) {
                if(result != 0 && result.code == 00){
                     $("#hiddenAttachmentPaySlip").val(result.data.fileGroupKey);
                    Common.ajax("POST", "/sales/posstock/insertPosEshop.do", $("#eshopForm").serializeJSON(), function(result) {
                        Common.alert('ESN Number is : '+result.data);
                        fn_close();

                       }, function(jqXHR, textStatus, errorThrown) {
                           try {
                               console.log("status : " + jqXHR.status);
                               console.log("code : " + jqXHR.responseJSON.code);
                               console.log("message : " + jqXHR.responseJSON.message);
                               console.log("detailMessage : "
                                       + jqXHR.responseJSON.detailMessage);
                           } catch (e) {
                               console.log(e);
                           }
                       });

                }else{
                    Common.alert("Attachment Upload Failed" + DEFAULT_DELIMITER + result.message);
                }
            },function(result){
                Common.alert("Upload Failed. Please check with System Administrator.");
            });
        }
    }

    function fn_close(){
        $("#popup_wrap").remove();
    }

    function setInputFile(){//인풋파일 세팅하기
        $(".auto_file").append("<label><span class='label_text'><a href='#'>Upload</a></span><input type='text' class='input_text' readonly='readonly' /></label>");
    }

</script>

<div id="popup_wrap" class="popup_wrap">
	<header class="pop_header">
		<!-- pop_header start -->
		<h1>e-Shop</h1>
		<ul class="right_opt">
			<li><p class="btn_blue2"><a href="#" id="btnOrdRegClose"><spring:message code="sal.btn.close" /></a></p></li>
		</ul>
	</header>
	<!-- pop_header end -->
    <form id="eshopForm" name="eshopForm" action="#" method="post">
	<section class="pop_body">
		<!-- pop_body start -->

		<section class="tap_wrap">
			<!-- tap_wrap start -->

			<ul class="tap_type1">
				<li><a href="#" class="on">Delivery Info</a></li>
				<li><a href="#">Catalog</a></li>
				<li><a href="#">Shopping Carts</a></li>
			</ul>


<!------------------------------------------------------------------------------
                                            Delivery Info
------------------------------------------------------------------------------->

	<article class="tap_area">
		<aside class="title_line">
			<h3>Contact Info</h3>
		</aside>

		<section>

<!-- 			<form id="instCntcForm" name="instCntcForm" action="#" method="post"> -->
				<input id="hiddenInstCntcId" name="instCntcId" type="hidden" />

				<table class="type1">
					<!-- table start -->
					<caption>table</caption>
					<colgroup>
						<col style="width: 120px" />
						<col style="width: *" />
						<col style="width: 120px" />
						<col style="width: *" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row"><spring:message code="sal.text.name" /></th>
							<td colspan="3"><input id="contactName" name="contactName" type="text" class="w100p readonly" readonly /></td>
						</tr>

						<tr>
							<th scope="row">Tel (Mobile)<span class="must">*</span></th>
							<td colspan="3"><input id="contactNo" name="contactNo" type="text" class="w100p" /></td>
						</tr>
					</tbody>
				</table>
				<!-- table end -->
<!-- 			</form> -->
		</section>


		<section>
			<aside class="title_line">
				<h3>Shopping Address Info</h3>
			</aside>
			<!-- title_line end -->

<!-- 			<form id="insAddressForm" name="insAddressForm" method="POST"> -->
				<input type="hidden" id="areaId" name="areaId"> <input type="hidden" value="${insCustId}" id="_insCustId" name="insCustId">
				<input type="hidden" name="addrCustAddId" value="${detailaddr.custAddId}" id="addrCustAddId">
				<!-- Temp Address Id -->
				<input type="hidden" name="tempAddrId" id="tempAddrId">
				<input type="hidden" name="tempAreaId" id="tempAreaId">
				<!-- Page Param -->
				<input type="hidden" name="callParam" id="_callParam" value="${callParam}">
				<table class="type1">
					<!-- table start -->
					<caption>table</caption>
					<colgroup>
						<col style="width: 40%" />
						<col style="width: *" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row"><spring:message code="sal.text.addressDetail" /><span class="must">*</span></th>
							<td><input type="text" title="" id="addrDtl" name="addrDtl" placeholder="eg. NO 10/UNIT 13-02-05/LOT 33945" class="w100p" maxlength="100" /></td>
						</tr>
						<tr>
							<th scope="row"><spring:message code="sal.text.street" /></th>
							<td><input type="text" title="" id="streetDtl" name="streetDtl" placeholder="eg. TAMAN/JALAN/KAMPUNG" class="w100p" maxlength="100" /></td>
						</tr>
						<tr>
							<th scope="row"><spring:message code="sal.text.state" /><span class="must">*</span></th>
							<td><select class="w100p" id="mState" name="mState" onchange="javascript : fn_selectState(this.value)"></select></td>
						</tr>
						<tr>
							<th scope="row"><spring:message code="sal.text.city" /><span class="must">*</span></th>
							<td><select class="w100p" id="mCity" name="mCity" onchange="javascript : fn_selectCity(this.value)"></select></td>
						</tr>
						<tr>
							<th scope="row"><spring:message code="sal.text.streetSearch" /><span class="must">*</span></th>
							<td>
							<input type="text" title="" id="searchSt" name="searchSt" placeholder="" class="" style="width: 155px;" /><a href="#" onclick="fn_addrSearch()" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
							</td>
						</tr>
						<tr>
							<th scope="row"><spring:message code="sal.text.postCode" /><span class="must">*</span></th>
							<td><select class="w100p" id="mPostCd" name="mPostCd" onchange="javascript : fn_selectPostCode(this.value)"></select></td>
						</tr>
						<tr>
							<th scope="row"><spring:message code="sal.text.area" /><span class="must">*</span></th>
							<td><select class="w100p" id="mArea" name="mArea" onchange="javascript : fn_getAreaId()"></select></td>
						</tr>
						<tr>
							<th scope="row"><spring:message code="sal.text.country" /><span class="must">*</span></th>
							<td><input type="text" title="" id="mCountry" name="mCountry" placeholder="" class="w100p readonly" readonly="readonly" value="Malaysia" /></td>
						</tr>
					</tbody>
				</table>
				<!-- table end -->
<!-- 			</form> -->
			<ul class="center_btns">
				<li><p class="btn_blue"><a href="#" onclick="fn_saveConfirm()"><spring:message code="sal.btn.save" /></a></p></li>
			</ul>

		</section>
		<!-- search_table end -->
	</article>
	<!-- tap_area end -->


<!--****************************************************************************
                                                           Catalog
*****************************************************************************-->
	<article class="tap_area">
		<!-- tap_area start -->

		<section class="search_table">

			<aside class=""><!-- title_line start -->
	            <ul class="right_btns">
	                <li><p class="btn_grid"><a id="btnSearchCatalog" onclick="javascript:selectCatalogList();"  ><span class="search"></span>Search</a></p></li>
	            </ul>
	        </aside><!-- title_line end -->

			<!-- search_table start -->

<!-- 			<form id="catalogForm" name="catalogForm" action="#" method="post"> -->

				<table class="type1">
					<!-- table start -->
					<caption>table</caption>
					<colgroup>
						<col style="width: 200px" />
						<col style="width: *" />
						<col style="width: 170px" />
						<col style="width: *" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">Branch / Warehouse</th>
							<td colspan="3"><select class="w100p" id="scnFromLocId" name="scnFromLocId"></select></td>
							<input type="hidden" id="esnFromLocId" name="esnFromLocId"/>
						</tr>

						<tr>
						      <th scope="row">Selling Type</th>
                               <td colspan="3"><select class="w100p" id="sellingType"  name="sellingType"></select></td>
                        </tr>
					</tbody>
				</table>
				<!-- table end -->

<!-- 			</form> -->
		</section>
		<!-- search_table end -->

		<section class="search_table" id="table_addToCart" style="display:none;"><!-- search_table start -->
<!-- 		<form action="#" method="post" id="form_addToCart"> -->
		<input type="hidden" id="cartGrpId" name="cartGrpId"/>
		<input type="hidden" id="cartEshopItemId" name="cartEshopItemId"/>
		<input type="hidden" id="cartItemLocId" name="cartItemLocId"/>

		<!-- title_line start -->
		<aside class="title_line"><h2>Detail</h2></aside>
		<!-- title_line end -->
        <div id="imgItem" ></div>
		<table class="type1 mt20"><!-- table start -->
		<caption>table</caption>
		<colgroup>
		    <col style="width:200px" />
		    <col style="width:*" />
		    <col style="width:150px" />
		    <col style="width:*" />
		</colgroup>
		<tbody>
		   <tr>
		            <th scope="row">Item</th>
		            <td colspan="3"><input type="text"  class="w100p readonly" id="item_addToCart"  name="item_addToCart"/></td>
		    </tr>
		    <tr>
                    <th scope="row">Size</th>
                    <td colspan="3"><input type="text"  class="w100p readonly" id="size_addToCart"  name="size_addToCart"/></td>
            </tr>
            <tr>
                    <th scope="row">Quantity Per Carton</th>
                    <td colspan="3"><input type="text"  class="w100p readonly"  id="qty_addToCart"  name="qty_addToCart"/></td>
            </tr>
            <tr>
                    <th scope="row">Price Per Carton</th>
                    <td colspan="3"><input type="text"  class="w100p readonly" id="price_addToCart"  name="price_addToCart"/></td>
            </tr>
            <tr>
                    <th scope="row">Weight Per Carton</th>
                    <td colspan="3"><input type="text"  class="w100p readonly" id="weight_addToCart"  name="weight_addToCart"/></td>
            </tr>
             <tr>
                    <th scope="row">Quantity Available (Carton)</th>
                    <td colspan="3"><input type="text"  class="w100p readonly" id="qtyAvailable_addToCart"  name="weight_addToCart"/></td>
            </tr>
		</tbody>
		</table>

		  <!-- title_line start -->
        <aside class="title_line"><h2>Purchase</h2></aside>
        <!-- title_line end -->

        <table class="type1"><!-- table start -->
        <caption>table</caption>
        <colgroup>
            <col style="width:200px" />
            <col style="width:*" />
            <col style="width:150px" />
            <col style="width:*" />
        </colgroup>
        <tbody>
           <tr>
                    <th scope="row">Ordering Quantity (Carton)</th>
                    <td colspan="3"><input type="text"  class="w100p" id="orderQty_addToCart"  name="orderQty_addToCart"/></td>
            </tr>
            <tr>
                    <th scope="row">Total Price</th>
                   <td colspan="3"><input type="text"  class="w100p readonly" id="totalPrice_addToCart"  name="totalPrice_addToCart"/></td>
            </tr>
        </tbody>
        </table>

        <ul class="center_btns">
            <li><p class="btn_blue"><a id="btnAdd" onclick="fn_addToCart()"><spring:message code="sal.btn.add" /></a></p></li>
            <li><p class="btn_blue"><a href="#"><spring:message code="sys.btn.cancel" /></a></p></li>
        </ul>

<!-- 		</form> -->
		</section>

		 <!-- title_line start -->
        <aside class="title_line"><h2>Selling Items</h2></aside>
        <!-- title_line end -->


		<div id="catalogImgList"></div>

		<ul class="center_btns">
			<li><p class="btn_blue"><a name="ordSaveBtn" href="#" onclick="fn_saveConfirm()"><spring:message code="sal.btn.save" /></a></p></li>
		</ul>

	</article><!-- tap_area end -->

<!--****************************************************************************
                                                           Shopping Carts
*****************************************************************************-->

	<article class="tap_area">
        <section>
            <aside class="title_line">
                <h3>Shopping Cart Info</h3>
            </aside>
            <!-- title_line end -->

                    <article><div id="item_grid_cart" style="width:100%; height:300px; margin:0 auto;"></div></article>

                    <!-- title_line start -->
                    <aside class="title_line"><h2>Summary Ordering</h2></aside>
                    <!-- title_line end -->

					<table class="type1 mt10">
						<!-- table start -->
						<caption>table</caption>
						<colgroup>
							<col style="width: 150px" />
							<col style="width: *" />
<!-- 							<col style="width: 150px" /> -->
						</colgroup>
						<tbody>
							<tr>
                                <th scope="row">Total Ordering</th>
                                <td><input type="text" id="totalOrdering" name="totalOrdering" /></td>
							</tr>
							<tr>
                                <th scope="row">Total Weight</th>
                                <td><input type="text"  id="totalWeight" name="totalWeight" /></td>
                            </tr>
                            <tr>
                                <th scope="row">Shipping Fee</th>
                                <td><input type="text"  id="totalShippingFee" name="totalShippingFee" /></td>
                            </tr>
                            <tr>
                                <th scope="row">Grand Total Price</th>
                                <td><input type="text" id="totalPrice" name="totalPrice" /></td>
                            </tr>
                              <tr>
                                <th scope="row" >Attachment<span class="must">*</span></th>
							    <td>
							    <div class="auto_file">
							            <input type="file" id="attachmentPaySlip" name="attachmentPaySlip" title="file add" />
							    </div>
							    </td>
                            </tr>


						</tbody>
					</table>
                    <input type="hidden" id="hiddenAttachmentPaySlip" name="hiddenAttachmentPaySlip"/>
					<ul class="center_btns">
                <li><p class="btn_blue"><a href="#" onclick="fn_saveConfirm()"><spring:message code="sal.btn.save" /></a></p></li>
            </ul>

        </section>
        <!-- search_table end -->
    </article>
    <!-- tap_area end -->
		</section>
		<!-- tap_wrap end -->
	</section>
	<!-- pop_body end -->
	</form>

</div>
<!-- popup_wrap end -->