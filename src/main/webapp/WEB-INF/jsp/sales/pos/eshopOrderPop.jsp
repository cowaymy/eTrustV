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

     $(document).ready(function() {

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
        Common.ajax("GET", "/sales/customer/insertCustomerAddressInfoAf.do",$("#insAddressForm").serialize(), function(result) {

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

    function fn_parentReload() {
        fn_selectPstRequestDOListAjax(); //parent Method (Reload)
        $("#_close1").click();
        $("#_close").click();
        $("#_selectParam").val('2');
        Common.popupDiv('/sales/customer/updateCustomerAddressPop.do' , $('#popForm').serializeJSON(), null , true, '_editDiv2');
        Common.popupDiv('/sales/customer/updateCustomerNewAddressPop.do', $('#popForm').serializeJSON(), null , true, '_editDiv2New');
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
        Common.popupDiv('/sales/customer/searchMagicAddressPop.do' , $('#insAddressForm').serializeJSON(), null , true, '_searchDiv');

       $("#mPostCd").attr({"disabled" : false  , "class" : "w100p"});

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

//     function showImage(){

//         Common.ajax("GET", "/sales/posstock/selectItemImageList", null, function(result) {
// //         	   $("#imgShow").html("<img src='\\resources\\WebShare"+result[0].filepath+"' width='250px' height='250px'>")
//         	   for(var i=0 ; i<result.length;i++){
//         		   var elem = document.createElement("img");
//                    elem.setAttribute("src", result[i].filepath);
//                    elem.setAttribute("height", "150px");
//                    elem.setAttribute("width", "150px");
//                    elem.setAttribute("id", result[i].id);
//                    elem.setAttribute("onclick", "imageDtl("+result[i].id+")");

//                    document.getElementById("placehere").appendChild(elem);
//         	   }

//         });

//     }

    function imageDtl(value){

    	   var param = {imgId: value};



    	   Common.ajax("GET", "/sales/posstock/selectItemList", param, function(result) {
               console.log(result);
               var elem = document.createElement("img");
               elem.setAttribute("src", "\\resources\\WebShare"+ result[0].filepath);
               elem.setAttribute("height", "200px");
               elem.setAttribute("width", "200px");
               elem.setAttribute("class", "centerImg");

               document.getElementById("imgItem").appendChild(elem);

               $("#item_addToCart").val(result[0].stkCode);
               $("#size_addToCart").val(result[0].itemSize);
               $("#qty_addToCart").val(result[0].itemQty);
               $("#price_addToCart").val(result[0].totalPrice);
               $("#weight_addToCart").val(result[0].totalWeight);
               $("#qtyAvailable_addToCart").val(result[0].stkCode);
           });
    }

    function selectCatalogList(){
//     	catalogForm
		   Common.ajax("GET", "/sales/posstock/selectCatalogList", $("#catalogForm").serializeJSON(), function(result) {
			   console.log(result);
			   for(var i=0 ; i<result.length;i++){
                   var elem = document.createElement("img");
                   elem.setAttribute("src", "\\resources\\WebShare"+ result[i].filepath);
                   elem.setAttribute("height", "150px");
                   elem.setAttribute("width", "150px");
                   elem.setAttribute("id", result[i].id);
                   elem.setAttribute("onclick", "imageDtl("+result[i].id+")");

                   document.getElementById("placehere").appendChild(elem);
               }


		   });
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

			<form id="instCntcForm" name="instCntcForm" action="#" method="post">
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
			</form>
		</section>


		<section>
			<aside class="title_line">
				<h3>Shopping Address Info</h3>
			</aside>
			<!-- title_line end -->

			<form id="insAddressForm" name="insAddressForm" method="POST">
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
			</form>
			<ul class="center_btns">
				<li><p class="btn_blue"><a name="ordSaveBtn" href="#"><spring:message code="sal.btn.ok" /></a></p></li>
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

			<form id="catalogForm" name="catalogForm" action="#" method="post">

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
						</tr>

						<tr>
						      <th scope="row">Selling Type</th>
                               <td colspan="3"><select class="w100p" id="sellingType"  name="sellingType"></select></td>
                        </tr>
					</tbody>
				</table>
				<!-- table end -->

			</form>
		</section>
		<!-- search_table end -->

		<section class="search_table" id="table_addToCart"><!-- search_table start -->
		<form action="#" method="post" id="form_addToCart">

		<!-- title_line start -->
		<aside class="title_line"><h2>Detail</h2></aside>
		<!-- title_line end -->
 <div id="imgItem" ></div>
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
		            <th scope="row">Item</th>
		            <td colspan="3"><input type="text"  class="w100p" id="item_addToCart"  name="item_addToCart"/></td>
		    </tr>
		    <tr>
                    <th scope="row">Size</th>
                    <td colspan="3"><input type="text"  class="w100p" id="size_addToCart"  name="size_addToCart"/></td>
            </tr>
            <tr>
                    <th scope="row">Quantity Per Carton</th>
                    <td colspan="3"><input type="text"  class="w100p" id="qty_addToCart"  name="qty_addToCart"/></td>
            </tr>
            <tr>
                    <th scope="row">Price Per Carton</th>
                    <td colspan="3"><input type="text"  class="w100p" id="price_addToCart"  name="price_addToCart"/></td>
            </tr>
            <tr>
                    <th scope="row">Weight Per Carton</th>
                    <td colspan="3"><input type="text"  class="w100p" id="weight_addToCart"  name="weight_addToCart"/></td>
            </tr>
             <tr>
                    <th scope="row">Quantity Available (Carton)</th>
                    <td colspan="3"><input type="text"  class="w100p" id="qtyAvailable_addToCart"  name="weight_addToCart"/></td>
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
                   <td colspan="3"><input type="text"  class="w100p" id="totalPrice_addToCart"  name="totalPrice_addToCart"/></td>
            </tr>
        </tbody>
        </table>

		</form>
		</section>

		<div id="placehere"></div>

<!-- 		<table class="type1"> -->
<!--                     <caption>search table</caption> -->
<!--                     <colgroup> -->
<!--                         <col style="width:69%" /> -->
<!--                         <col style="width:1%" /> -->
<!--                         <col style="width:30%" /> -->
<!--                     </colgroup> -->
<!--                     <tbody> -->
<!--                     <tr> -->
<!--                         <td  style="text-align: left;"> -->
<!--                             <div id="stock_img_div" style="width:100%;"></div></td> -->
<!--                         <td >&nbsp;</td> -->
<!--                         <td id="imgShow"></td> -->
<!--                     </tr> -->
<!--                 </table> -->

		<ul class="center_btns">
			<li><p class="btn_blue"><a name="ordSaveBtn" href="#"><spring:message code="sal.btn.ok" /></a></p></li>
		</ul>

	</article>
			<!-- tap_area end -->
		</section>
		<!-- tap_wrap end -->
	</section>
	<!-- pop_body end -->
</div>
<!-- popup_wrap end -->