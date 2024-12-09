<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">
    var arrSrvTypeCode = [
                                     {"codeId": "SS"  ,"codeName": "Self Service"},
                                     {"codeId": "HS" ,"codeName": "Heart Service"}
                                   ];

    var appType = '${configBasicInfo.appTypeCode}';
    var promoItmSrvType = '${promoInfo.promoItmSrvType}';
    var totOutStandingAmt = '${ordOutInfo.ordTotOtstnd}';
    // [Project ID 7139026265] Self Service (DIY) Project add by Fannie - 05/12/2024
    // HS Configuration @ Service mode only update in history logs and month end update on changed service mode
    var srvType = '${serviceType.srvType}';
    var srvTypeChangeCnt = '${srvTypeChgTimes}';

    var srvTypeChgHistoryLogGridID;

    var srvTypeHistoryColumnLayout = [
                                                        {dataField : "srvCrtDt", headerText : "<spring:message code='service.title.CreateDate'/>", width:150, editable : false , dataType : "date", formatString : "dd/mm/yyyy"},
                                                        {dataField : "srvTypeChgFrom", headerText : "<spring:message code='service.title.from'/>", width:80, editable : false},
                                                        {dataField : "srvTypeChgTo", headerText : "<spring:message code='service.title.to'/>", width:80, editable : false},
                                                        {dataField : "remark", headerText : "<spring:message code='service.title.Remark'/>", width:400, editable : false},
                                                        {dataField : "creator", headerText : "<spring:message code='service.title.Creator'/>", width:150, editable : false},
                                                     ];

    var srvTypeHistoryGridPros = {
                                          		  usePaging : true,
                                                  pageRowCount : 20,
                                                  headerHeight : 40,
                                                  height : 240,
                                                  enableFilter : true,
                                                  selectionMode : "multipleCells"
                                              };

    //doGetCombo('/services/bs/getHSCody.do?&SRV_SO_ID='+'${configBasicInfo.ordNo}', '', '','entry_cmbServiceMem', 'S' , '');
	  $(document).ready(function() {
	    	 doDefCombo(arrSrvTypeCode, '', 'cmbSrvType', 'S', '');
	    	//Added by keyi HS Configuration (Basic Info) for Cody Level 202206
	    	  var userType = '${SESSION_INFO.userTypeId}';

	    	  if ("${SESSION_INFO.memberLevel}" == "4" && userType == 2) {
	                $("#entry_cmbServiceMem").prop("disabled",true);
	                $("#entry_availability").prop("disabled",true);
	                $("#entry_settIns").prop("disabled",true);
	                $("#entry_settHs").prop("disabled",true);
	                $("#entry_settAs").prop("disabled",true);
	                $("#btnSaveConfig").hide();
	          }
	    	  else {
	    		  $("#entry_cmbServiceMem").prop("disabled",false);
                  $("#entry_availability").prop("disabled",false);
                  $("#entry_settIns").prop("disabled",false);
                  $("#entry_settHs").prop("disabled",false);
                  $("#entry_settAs").prop("disabled",false);
                  $("#btnSaveConfig").show();
	    	  }

	    	//doGetCombo('/services/bs/selectHSCodyList.do', { codyMangrUserId : $("#codyMangrUserId").val(), custId : $("#custId").val()} , '', 'entry_cmbServiceMem' , 'S', '');

	    	CommonCombo.make("entry_cmbServiceMem", '/services/bs/selectHSCodyList.do', { codyMangrUserId : $("#codyMangrUserId").val(), entry_orderNo : $("#entry_orderNo").val()}, '${configBasicInfo.c2}', {isShowChoose: true});

	        //{ salesOrdNo :  $("#salesOrdNo").val() }
	    	/* Common.ajax("GET",'/services/bs/getHSCody.do?&SRV_SO_ID='+'${configBasicInfo.ordNo}', ' ',function(result) {

	    		if(result != null && result.length != 0 ){
	              var serMember =result.memCode;
	              console.log("serMember:"+serMember);

	              $('#entry_cmbServiceMem').val(serMember);
	    		}
	          });  */

	           fn_getHSConfigBasicInfo();

               var configBsGen = '${configBasicInfo.configBsGen}';
               $("#entry_availability option[value="+configBsGen +"]").attr("selected", true);

               //var checkProduct = ${configBasicInfo.stockCode}
               if('${configBasicInfo.stockCode}' != "112789"){  // PRODUCT - OMBAK THEN DISPLAY FAUCET CHECKBOX
            	   $('#faucetTitle').hide();
            	   $('#faucet_exch').hide();

               }

             //if('${configBasicInfo.faucetExch}' != ''){
               var checked = '${configBasicInfo.faucetExch}';

               if(checked == '1'){ // DISABLE EDIT CHECKBOX IF CHECKED = 1
            	   console.log('checked = 1')
            	   $("#faucet_exch").prop("disabled",true);
               }

	          //var srvMemId =  ${configBasicInfo.configBsMemId}
             //$("#entry_cmbServiceMem").val($("entry_cmbServiceMem option:first").val());

             //$("#entry_cmbServiceMem option:eq(0)").remove();

             //var index = $("entry_cmbServiceMem").index($("entry_cmbServiceMem option:selected"));
             //alert("index"+index);
             //$("#entry_cmbServiceMem option").removeAttr('selected').find(':first').attr('selected','selected');
             //alert($("entry_cmbServiceMem option").size());

             //$("#orgGrCombo option:eq(1)").attr("selected", "selected");

               // [Project ID 7139026265] Self Service (DIY) Project add by Fannie - 05/12/2024
              // HS Configuration @ Service mode only update in history logs and month end update on changed service mode
               if(srvType == ''){
            	   $("#cmbSrvType option[value="+'${configBasicInfo.srvType}'+"]").attr("selected", true);
               }else{
            	    $("#cmbSrvType option[value="+srvType +"]").attr("selected", true);
               }
               $("#txtSrvTypeChangeCount").val(srvTypeChangeCnt);

               if(appType == "REN" && totOutStandingAmt == "0.00"){
                    if (srvType != promoItmSrvType ){
                	   $("#cmbSrvType").prop("disabled",false);
                   } else{
                	   $("#cmbSrvType").prop("disabled",true);
                   }

                    if(srvType === "SS"){
                        $("#entry_cmbServiceMem").prop("disabled",true);
                    }else{
                        $("#entry_cmbServiceMem").prop("disabled",false);
                    }
                }
                srvTypeChgHistoryLogGridID = AUIGrid.create("#srvTypeHistoryLog_view_grid_wrap", srvTypeHistoryColumnLayout, srvTypeHistoryGridPros);
                fn_getSrvTypeChgHistoryLogInfo(); //Get the service type changes history log information in gridview

                document.getElementById("cmbSrvType").addEventListener("change", function(){
                	  var selectedValue = this.value;

                	  if(selectedValue === "SS"){
                          $("#entry_cmbServiceMem").prop("disabled",true);
                      }else{
                          $("#entry_cmbServiceMem").prop("disabled",false);
                      }
                 });
	    });

	 function fn_getSrvTypeChgHistoryLogInfo(){
		 Common.ajax("GET", "/services/bs/getSrvTypeChgHistoryLogInfo.do",{salesOrdId: '${configBasicInfo.ordId}'}, function(result){
			 AUIGrid.setGridData(srvTypeChgHistoryLogGridID, result);
		 });
	 }

     function fn_getHSConfigBasicInfo(){
            Common.ajax("GET", "/services/bs/getHSConfigBasicInfo.do", $("#frmBasicInfo").serialize(), function(result) {
                  console.log("fn_getHSConfigBasicInfo.");
                 // console.log("cmbServiceMemList {}" + result);
             });
     }

     function fn_doSave(){
          Common.ajax("GET", "/services/bs/checkMemCode", { hscodyId : $('#entry_cmbServiceMem').val() }, function(result) {
              console.log("::::::::::::::ajax::::::::::::::");
              console.log(result);

              if (!fn_validBasicInfo()) {
                  return;
              }

             var checkSuccess = {message: "fail"};

              if(result.message === checkSuccess.message) {
            	  Common.alert("Not Available to entry in the statue of the cody");
            	  return;
              }
              else
            	  fn_doSaveBasicInfo();
           });
    }

     function fn_validBasicInfo(){
           var isValid = true, msg = "";

           if($('#entry_availability').val() <= -1 ){
                msg += "* Please select the BS availability.<br />";
                isValid = false;
          }

          if ($('#entry_cmbServiceMem').val() <= -1){
                msg += "* Please select the BS incharge cody.<br />";
                isValid = false;
          }

          if($('#entry_lstHSDate').val() == "") {
                $('#entry_lstHSDate').val("01/01/1900");
          }

          if(!isValid)
        	  Common.alert("<b>" + message +  DEFAULT_DELIMITER + "<b>"+msg+"</b>");
         return isValid;
    }

   function  fn_doSaveBasicInfo(){
       var srvTypeChangeCount = parseInt($("#txtSrvTypeChangeCount").val(), 10);

       if(srvTypeChangeCount >= 2) {
           Common.alert("* The service type only able to change maximum 2 times.");
           return;
       }

       if(promoItmSrvType == "SS" && $("#cmbSrvType").val() != "SS"){
           Common.alert("* The service type (" + $("#cmbSrvType").val() +") must same with service type of promotion product ("+promoItmSrvType+")");
           return;
       }else if(promoItmSrvType == "HS" && $("#cmbSrvType").val() != "HS"){
           Common.alert("* The service type (" + $("#cmbSrvType").val() +") must same with service type of promotion product ("+promoItmSrvType+").<br/>");
           return;
       }else if($("#cmbSrvType").val() == "SS" && totOutStandingAmt != "0.00"){
           Common.alert("* The total outstanding amount must be zero!");
           return;
       }

        var hsResultM ={
                   availability:  $("#entry_availability").val(),
                   cmbServiceMem: $('#entry_cmbServiceMem').val(),
                   lstHSDate: $('#entry_lstHSDate').val(),
                   remark: $('#entry_remark').val(),
                   settIns: $('#entry_settIns').prop("checked") ? '1': '0',
                   settHs: $('#entry_settHs').prop("checked") ? '1': '0',
                   settAs: $('#entry_settAs').prop("checked") ? '1': '0',
                   srvBsWeek: $(':input[name=entry_srvBsWeek]:radio:checked').val(),
                   salesOrderId: $('#salesOrderId').val(),
                   configId: $('#configId').val(),
                   hscodyId:$('#hscodyId').val(),
                   srvSoId:$('#entry_orderNo').val(),
                   entry_cmbServiceMem: $('#entry_cmbServiceMem').val(),
                   faucetExch: $('#faucet_exch').prop("checked") ? '1': '0',
                   serviceType: $('#cmbSrvType').val(),
                   serviceTypeChangeCount: $('#txtSrvTypeChangeCount').val(),
                   oldSrvType: $('#oldSvcType').val(),
                   appTypeId: '${promoInfo.appTypeId}',
                   ordSrvPacId: '${promoInfo.srvPacId}',
                   ordMthRentAmt: '${promoInfo.mthRentAmt}',
                   promoItmPv : '${promoInfo.promoItmPv}',
                   promoItmPvSs : '${promoInfo.promoItmPvSs}'
        }

        var  saveForm ={
            "hsResultM": hsResultM
        }

        Common.ajax("POST", "/services/bs/saveHsConfigBasic.do", saveForm, function(result) {
            console.log("saved.");
            console.log(result);

            Common.alert("<b>HS result successfully saved.</b>", fn_close);
        });
    }

    function fn_close(){
        $("#popup_wrap").remove();
         fn_parentReload();
    }

    function fn_parentReload() {
        fn_getBasicListAjax(); //parent Method (Reload)
    }


 /*     $('#btnSaveBasicInfo').click(function() {

        if(!fn_hsBasicSave()) return false;

         //   fn_doSaveBasicInfo();

           alert(222222222);
        Common.ajax("POST", "/services/saveHsConfigBasic.do",  $("#frmBasicInfo").serializeJSON(), function(result) {
                        Common.alert("BS basic info setting successfully updated." + DEFAULT_DELIMITER + "<b>"+result.message+"</b>", fn_reloadPage);

            }, function(jqXHR, textStatus, errorThrown) {
                try {
                    Common.alert("Failed to save. Please try again later." + DEFAULT_DELIMITER + "<b>Failed To Save.<br />"+"Error message : " + jqXHR.responseJSON.message + "</b>");
                }
                catch(e) {
                    console.log(e);
                }
            }
        });

    } */

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
   <header class="pop_header"><!-- pop_header start -->
     <h1>
        <spring:message code='service.title.HSManagement'/> - <spring:message code='service.title.Configuration'/> - <spring:message code='service.title.BasicInfo'/>
      </h1>
      <ul class="right_opt">
         <li>
               <p class="btn_blue2">
                  <a href="#"><spring:message code='expense.CLOSE'/></a>
               </p>
         </li>
      </ul>
  </header><!-- pop_header end -->

  <section class="pop_body"><!-- pop_body start -->
     <section class="tap_wrap">
        <ul class="tap_type1">
          <li>
            <a href="#" class="on" id="basicInfo"><spring:message code='service.title.BasicInfo' /></a>
          </li>
          <li>
            <a href="#"><spring:message code='service.title.srvTypeChangeHistoryLog' /></a>
          </li>
        </ul>
       <article class="tap_area">
         <form id="frmBasicInfo" method="post">
            <%-- <input id="salesOrderId" name="salesOrderId" type="hidden" value="${basicInfo.ordId}"/> --%>
            <input type="hidden" name="salesOrderId"  id="salesOrderId" value="${SALEORD_ID}"/>
            <input type="hidden" name="configId"  id="configId" value="${configBasicInfo.configId}"/>
            <input type="hidden" name="brnchId"  id="brnchId" value="${BRNCH_ID}"/>
            <input type="hidden" name="hscodyId"  id="hscodyId" value="${configBasicInfo.configBsMemId}"/>
            <input type="hidden" name="configBsRem"  id="configBsRem" value="${configBasicInfo.configBsRem}"/>
            <input type="hidden" name="codyMangrUserId" id="codyMangrUserId" value="${CODY_MANGR_USER_ID}"/>
            <input type="hidden" name="custId" id="custId" value="${CUST_ID}"/>
            <input type="hidden" name="oldSvcType" id="oldSvcType" value="${serviceType.srvType}"/>

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
                    <th scope="row" ><spring:message code='service.title.OrderNo'/></th>
                   <%--  <td><span><c:out value="${basicInfo.ordNo}"/></span> --%>
                    <td>
                    <input type="text" title="" id="entry_orderNo" name="entry_orderNo"  value="${configBasicInfo.ordNo}" placeholder="" class="w100p readonly " readonly="readonly" style="width: 188px; " />
                    </td>
                    <th scope="row" ><spring:message code='service.title.ApplicationType'/></th>
                    <td>
                    <input type="text" title="" id="entry_appType" name="entry_appType"  value="${configBasicInfo.appTypeCode}" placeholder="" class="w100p readonly " readonly="readonly" style="width: 157px; "/>
                    </td>
                </tr>
                <tr>
                    <th scope="row" ><spring:message code='service.title.InstallationAddress'/></th>
                    <td>
                    <input type="text" title="" id="entry_address" name="entry_address"  value="${configBasicInfo.appTypeCode}" placeholder="" class="w100p readonly " readonly="readonly" style="width: 188px; "/>
                    </td>
                        <th scope="row" ><spring:message code='service.title.CustomerName'/></th>
                    <td>
                    <input type="text" title="" id="entry_custName" name="entry_custName"  value="${configBasicInfo.custName}" placeholder="" class="w100p readonly " readonly="readonly" style="width: 157px; "/>
                    </td>
                </tr>
                <tr>
                    <th scope="row" ><spring:message code='service.title.Product'/></th>
                      <td>
                         <input type="text" title="" id="entry_product" name="entry_product"  value="${configBasicInfo.stock}" placeholder="" class="w100p readonly " readonly="readonly" style="width: 188px; "/>
                      </td>
                    <th id = "faucetTitle" scope="row" >Body Ambient Assy Replacement</th>
                    <td>
                        <label><input type="checkbox" id="faucet_exch" name="faucet_exch" <c:if test="${configBasicInfo.faucetExch == 1}">checked</c:if> /></label>
                    </td>
                  </tr>
                  <tr>
                        <th scope="row"><spring:message code='sales.srvType'/></th>
                        <td><select class="w100p" id="cmbSrvType" name="cmbSrvType"></td>
                        <th scope="row"><spring:message code='sales.srvTypeChangeCount'/></th>
                        <td><input type="text" title="" id="txtSrvTypeChangeCount" name="txtSrvTypeChangeCount"  value="" placeholder="" class="w100p readonly " readonly="readonly" style="width: 157px; "/></td>
                    </tr>
                    <tr>
                        <th scope="row" ><spring:message code='service.title.NRIC_CompanyNo'/></th>
                        <td>
                        <input type="text" title="" id="entry_nric" name="entry_nric"  value="${configBasicInfo.custNric}" placeholder="" class="w100p readonly " readonly="readonly" style="width: 188px; "/>
                        </td>
                        <th scope="row" ><spring:message code='service.title.HSAvailability'/></th>
                        <td>
                    <%--<input type="text" title="" id="entry_availability" name="entry_availability"  value="${BasicInfo.custNric}" placeholder="" class="readonly " readonly="readonly" style="width: 464px; "/> --%>
                        <select class="w100p" id="entry_availability" name="entry_availability">
                            <option value="1">Available</option>
                            <option value="0">Unavailable</option>
                        </select>

                        </td>
                    </tr>
                    <tr>
                        <th scope="row" ><spring:message code='service.title.HSCodyCode'/></th>
                        <td>
                            <!-- <input type="text" id="entry_cmbServiceMem" name="entry_cmbServiceMem" title="Member Code"  class="w100p" /> -->
                            <select class="w100p" id="entry_cmbServiceMem" name="entry_cmbServiceMem">
                            <!-- <option value="" selected="selected">dd</option>-->
                            </select>
                        </td>
                        <th scope="row" ><spring:message code='service.title.LastHSDate'/></th>
                        <td>
                        <input type="text" id="entry_lstHSDate" name="entry_lstHSDate" title="Create start Date" value="${configBasicInfo.c4}" placeholder="DD/MM/YYYY" class="w100p readonly " readonly="readonly" />
                        </td>
                    </tr>
                    <tr>
                        <th scope="row" ><spring:message code='service.title.Remark'/></th>
                        <td colspan="3">
                         <textarea cols="20" rows="5" id="entry_remark" name="entry_remark" placeholder="" > ${configBasicInfo.configBsRem} </textarea>
                    </tr>
                    <tr>
                        <th scope="row" ><spring:message code='service.title.HappyCallService'/></th>
                        <td colspan="3">
                        <label><input type="checkbox" id="entry_settIns" name="entry_settIns" <c:if test="${configBasicInfo.configSettIns == 1}">checked</c:if> /><span>Installation Type</span></label>
                        <label><input type="checkbox" id="entry_settHs" name="entry_settHs" <c:if test="${configBasicInfo.configSettBs == 1}">checked</c:if>/><span>BS Type</span></label>
                        <label><input type="checkbox" id="entry_settAs" name="entry_settAs" <c:if test="${configBasicInfo.configSettAs == 1}">checked</c:if>/><span>AS Type</span></label>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row" ><spring:message code='service.title.PreferHSWeek'/></th>
                        <td colspan="3">
                        <label><input type="radio" id="entry_srvBsWeek" name="entry_srvBsWeek" value="0" <c:if test="${configBasicInfo.configBsWeek == 0}">checked</c:if> disabled/><span>None</span></label>
                        <label><input type="radio" id="entry_srvBsWeek" name="entry_srvBsWeek" value="1" <c:if test="${configBasicInfo.configBsWeek == 1}">checked</c:if>/><span>Week 1</span></label>
                        <label><input type="radio" id="entry_srvBsWeek" name="entry_srvBsWeek" value="2" <c:if test="${configBasicInfo.configBsWeek == 2}">checked</c:if>/><span>Week 2</span></label>
                        <label><input type="radio" id="entry_srvBsWeek" name="entry_srvBsWeek" value="3" <c:if test="${configBasicInfo.configBsWeek == 3}">checked</c:if>/><span>Week 3</span></label>
                        <label><input type="radio" id="entry_srvBsWeek" name="entry_srvBsWeek" value="4" <c:if test="${configBasicInfo.configBsWeek == 4}">checked</c:if>/><span>Week 4</span></label>
                        </td>
                    </tr>
                    </tbody>
                    </table><!-- table end -->
             </form>
        </article>
        <article class="tap_area">
           <section class="search_result">
              <article class="grid_wrap">
                <div id="srvTypeHistoryLog_view_grid_wrap" style="width: 100%; margin: 0 auto;"></div>
              </article>
           </section>
        </article>
        <br/>
        <ul class="center_btns">
            <li><p class="btn_blue2 big"><a href="#" id="btnSaveConfig" onclick="fn_doSave()"><spring:message code='service.btn.SAVE'/></a></p></li>
        </ul>
     </section>
   </section><!-- pop_body end -->
</div><!-- popup_wrap end -->