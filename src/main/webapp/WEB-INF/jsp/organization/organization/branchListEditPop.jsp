<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">
  //Choose Message
  var optionState = {
    chooseMessage : " 1.States "
  };
  var optionCity = {
    chooseMessage : "2. City"
  };
  var optionPostCode = {
    chooseMessage : "3. Post Code"
  };
  var optionArea = {
    chooseMessage : "4. Area"
  };

  function fn_updateInitField(tempState, tempCity, tempPostCode, tempArea) {

    //State
    if ('' != tempState && null != tempState) {

      CommonCombo.make('mState', "/sales/customer/selectMagicAddressComboList", '', tempState, optionState);
    } else {

      CommonCombo.make('mState', "/sales/customer/selectMagicAddressComboList", '', '', optionState);
      fn_selectState('');
      return;

    }

    //City
    var cityJson = {
      state : tempState
    }; //Condition
    if ('' != tempCity && null != tempCity) {

      CommonCombo.make('mCity', "/sales/customer/selectMagicAddressComboList", cityJson, tempCity, optionCity);

    } else {
      CommonCombo.make('mCity', "/sales/customer/selectMagicAddressComboList", cityJson, '', optionCity);

      fn_selectCity('');
      return;
    }

    //PostCode
    var postCodeJson = {
      state : tempState,
      city : tempCity
    }; //Condition
    if ('' != tempPostCode && null != tempPostCode) {

      CommonCombo.make('mPostCd', "/sales/customer/selectMagicAddressComboList", postCodeJson, tempPostCode, optionPostCode);

    } else {
      CommonCombo.make('mPostCd', "/sales/customer/selectMagicAddressComboList", postCodeJson, '', optionPostCode);

      fn_selectPostCode('');
      return;
    }

    //Area
    var areaJson = {
      state : tempState,
      city : tempCity,
      postcode : tempPostCode
    }; //Condition
    if ('' != tempArea && null != tempArea) {
      CommonCombo.make('mArea', "/sales/customer/selectMagicAddressComboList", areaJson, tempArea, optionArea);

    } else {
      CommonCombo.make('mArea', "/sales/customer/selectMagicAddressComboList", areaJson, '', optionArea);

      return;
    }

  }

  //doGetCombo('/common/selectCodeList.do', '45', '','branchType', 'S' , ''); //branchType

  //Start AUIGrid
  $(document).ready(function() {

    var branchId = "${branchDetail.typeId}";
    $("#branchType option[value='" + branchId + "']").attr("selected", true);
    var codeId = $("#regionValue").val();
    CommonCombo.make('cmRegion', "/common/selectCodeList.do", {
      groupCode : '49'
    }, codeId, '');
    var tempState = $("#getState").val();
    var tempCity = $("#getCity").val();
    var tempPostCode = $("#getPostCode").val();
    var tempArea = $("#getArea").val();

    fn_updateInitField(tempState, tempCity, tempPostCode, tempArea);
  });

  //Update
  function fn_branchSave() {

    if (validRequiredField()) {
      $("select[name=branchType]").removeAttr("disabled");
      Common.ajax("GET", "/organization/branchListUpdate.do", $("#branchForm").serialize(), function(result) {
        console.log(result);
        Common.alert("Branch Save successfully.", fn_close);
      });

    }

  }

  function fn_close() {
    $("#popup_wrap").remove();
    fn_getBranchListAjax();
  }
  function validRequiredField() {
    /* if($("#branchCd").val() == ''){
      Common.alert("Please key  in Branch Code");
      return false;
    } */

    var label = "";

    if ($("#branchName").val() == '') {
      label = "<spring:message code='sys.title.branch.name' />";
      Common.alert("<spring:message code='sys.msg.necessary' arguments='" + label + "' htmlEscape='false'/>");
      return false;
    }
    if ($("#cmRegion").val() == '') {
      label = "<spring:message code='sal.title.text.region' />";
      Common.alert("<spring:message code='sys.msg.necessary' arguments='" + label + "' htmlEscape='false'/>");
      return false;
    }

    if ($("#addrDtl").val() == '') {
      label = "<spring:message code='sal.text.addressDetail' />";
      Common.alert("<spring:message code='sys.msg.necessary' arguments='" + label + "' htmlEscape='false'/>");
      return false;
    }

    if ($("#mArea").val() == '' || $("#mArea").val() == null) {
      label = "<spring:message code='sal.text.area4' />";
      Common.alert("<spring:message code='sys.msg.necessary' arguments='" + label + "' htmlEscape='false'/>");
      return false;
    }

    if ($("#mCity").val() == '' || $("#mCity").val() == null) {
      label = "<spring:message code='sal.text.city2' />";
      Common.alert("<spring:message code='sys.msg.necessary' arguments='" + label + "' htmlEscape='false'/>");
      return false;
    }

    if ($("#mPostCd").val() == '') {
      label = "<spring:message code='sal.text.postCode3' />";
      Common.alert("<spring:message code='sys.msg.necessary' arguments='" + label + "' htmlEscape='false'/>");
      return false;
    }

    if ($("#mState").val() == '') {
      label = "<spring:message code='sal.text.state1' />";
      Common.alert("<spring:message code='sys.msg.necessary' arguments='" + label + "' htmlEscape='false'/>");
      return false;
    }

    if ($("#costCenter").val() == '') {
      label = "<spring:message code='budget.CostCenter' />";
      Common.alert("<spring:message code='sys.msg.necessary' arguments='" + label + "' htmlEscape='false'/>");
      return false;
    }

    if ($("#txtLongtitude").val() != '') {
      if (!this.isDecimal($("#txtLongtitude").val())) {
        label = "<spring:message code='txtLongtitude' />";
        Common.alert("<spring:message code='sys.msg.invalid' arguments='" + label + "' htmlEscape='false'/>");
        return false;
      }
   }

    if ($("#txtLatitude").val() != '') {
      if (!this.isDecimal($("#txtLatitude").val())) {
        label = "<spring:message code='txtLatitude' />";
        Common.alert("<spring:message code='sys.msg.invalid' arguments='" + label + "' htmlEscape='false'/>");
        return false;
      }
   }

    return true;
  }

  function fn_addrSearch() {
    if ($("#searchSt").val() == '') {
      Common.alert("Please search.");
      return false;
    }
    Common.popupDiv('/sales/customer/searchMagicAddressPop.do', $('#branchForm').serializeJSON(), null, true, '_searchDiv'); //searchSt
  }
  function fn_addMaddr(marea, mcity, mpostcode, mstate, areaid, miso) {

    if (marea != "" && mpostcode != "" && mcity != "" && mstate != "" && areaid != "" && miso != "") {

      $("#mArea").attr({
        "disabled" : false,
        "class" : "w100p"
      });
      $("#mCity").attr({
        "disabled" : false,
        "class" : "w100p"
      });
      $("#mPostCd").attr({
        "disabled" : false,
        "class" : "w100p"
      });
      $("#mState").attr({
        "disabled" : false,
        "class" : "w100p"
      });

      //Call Ajax
      CommonCombo.make('mState', "/sales/customer/selectMagicAddressComboList", '', mstate, optionState);

      var cityJson = {
        state : mstate
      }; //Condition
      CommonCombo.make('mCity', "/sales/customer/selectMagicAddressComboList", cityJson, mcity, optionCity);

      var postCodeJson = {
        state : mstate,
        city : mcity
      }; //Condition
      CommonCombo.make('mPostCd', "/sales/customer/selectMagicAddressComboList", postCodeJson, mpostcode, optionCity);

      var areaJson = {
        groupCode : mpostcode
      };
      var areaJson = {
        state : mstate,
        city : mcity,
        postcode : mpostcode
      }; //Condition
      CommonCombo.make('mArea', "/sales/customer/selectMagicAddressComboList", areaJson, marea, optionArea);

      $("#areaId").val(areaid);
      $("#_searchDiv").remove();
    } else {
      Common.alert("Please check your address.");
    }
  }
  //Get Area Id
  function fn_getAreaId() {
    var statValue = $("#mState").val();
    var cityValue = $("#mCity").val();
    var postCodeValue = $("#mPostCd").val();
    var areaValue = $("#mArea").val();

    if ('' != statValue && '' != cityValue && '' != postCodeValue && '' != areaValue) {
      var jsonObj = {
        statValue : statValue,
        cityValue : cityValue,
        postCodeValue : postCodeValue,
        areaValue : areaValue
      };
      Common.ajax("GET", "/sales/customer/getAreaId.do", jsonObj, function(result) {
        $("#areaId").val(result.areaId);
      });
    }
  }

  function fn_selectCity(selVal) {

    var tempVal = selVal;

    if ('' == selVal || null == selVal) {

      $('#mPostCd').append($('<option>', {
        value : '',
        text : '3. Post Code'
      }));
      $('#mPostCd').val('');
      $("#mPostCd").attr({
        "disabled" : "disabled",
        "class" : "w100p disabled"
      });

      $('#mArea').append($('<option>', {
        value : '',
        text : '4. Area'
      }));
      $('#mArea').val('');
      $("#mArea").attr({
        "disabled" : "disabled",
        "class" : "w100p disabled"
      });

    } else {

      $("#mPostCd").attr({
        "disabled" : false,
        "class" : "w100p"
      });

      $('#mArea').append($('<option>', {
        value : '',
        text : '4. Area'
      }));
      $('#mArea').val('');
      $("#mArea").attr({
        "disabled" : "disabled",
        "class" : "w100p disabled"
      });

      //Call ajax
      var postCodeJson = {
        state : $("#mState").val(),
        city : tempVal
      }; //Condition
      CommonCombo.make('mPostCd', "/sales/customer/selectMagicAddressComboList", postCodeJson, '', optionPostCode);
    }

  }

  function fn_selectPostCode(selVal) {

    var tempVal = selVal;

    if ('' == selVal || null == selVal) {

      $('#mArea').append($('<option>', {
        value : '',
        text : '4. Area'
      }));
      $('#mArea').val('');
      $("#mArea").attr({
        "disabled" : "disabled",
        "class" : "w100p disabled"
      });

    } else {

      $("#mArea").attr({
        "disabled" : false,
        "class" : "w100p"
      });

      //Call ajax
      var areaJson = {
        state : $("#mState").val(),
        city : $("#mCity").val(),
        postcode : tempVal
      }; //Condition
      CommonCombo.make('mArea', "/sales/customer/selectMagicAddressComboList", areaJson, '', optionArea);
    }

  }

  function fn_initAddress() {

    $("#mPostCd").attr({
      "disabled" : "disabled",
      "class" : "w100p disabled"
    });
    $("#mPostCd").val('');

    $("#mCity").attr({
      "disabled" : "disabled",
      "class" : "w100p disabled"
    });
    $("#mCity").val('');

    $("#mArea").attr({
      "disabled" : "disabled",
      "class" : "w100p disabled"
    });
    $("#mArea").val('');
  }

  function fn_selectState(selVal) {

    var tempVal = selVal;

    if ('' == selVal || null == selVal) {
      //전체 초기화
      fn_initAddress();

    } else {

      $("#mCity").attr({
        "disabled" : false,
        "class" : "w100p"
      });

      $('#mPostCd').append($('<option>', {
        value : '',
        text : '3. Post Code'
      }));
      $('#mPostCd').val('');
      $("#mPostCd").attr({
        "disabled" : "disabled",
        "class" : "w100p disabled"
      });

      $('#mArea').append($('<option>', {
        value : '',
        text : '4. Area'
      }));
      $('#mArea').val('');
      $("#mArea").attr({
        "disabled" : "disabled",
        "class" : "w100p disabled"
      });

      //Call ajax
      var cityJson = {
        state : tempVal
      }; //Condition
      CommonCombo.make('mCity', "/sales/customer/selectMagicAddressComboList", cityJson, '', optionCity);
    }
  }

  function isDecimal(inputValue) {
    const decimalPattern = /^\d+(\.\d+)?$/;
    return decimalPattern.test(inputValue);
  }

  function fn_searchLocation(){
    var location = [{"lattitude": $('#txtLatitude').val(), "longtitude": $('#txtLongtitude').val()}];

    var prm = { "coordinate" : JSON.stringify(location),
                     "callFunc" : "1",
                     "callBack" : "callBackMap"};
    Common.popupDiv("/common/mapPop.do", prm , null, true, '_searchDiv');
  }

  function callBackMap(rtn) {
    $('#txtLatitude').val(rtn.params.latitude);
    $('#txtLongtitude').val(rtn.params.longitude);
  }
</script>
<div id="popup_wrap" class="popup_wrap">
  <header class="pop_header">
    <h1><spring:message code='txtBranchMgnmt' /> - <spring:message code='sys.btn.edit' /></h1>
    <ul class="right_opt">
      <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
    </ul>
  </header>
  <section class="pop_body">
    <form id="branchForm" name="branchForm">
      <input type="hidden" id="areaId" name="areaId" value="${branchDetail.c1}" />
      <input type="hidden" id="getState" value="${branchAddr.state}">
      <input type="hidden" id="getCity" value="${branchAddr.city}">
      <input type="hidden" id="getPostCode" value="${branchAddr.postcode}">
      <input type="hidden" id="getArea" value="${branchAddr.area}">
      <input type="hidden" id='branchNo' name='branchNo' value="${branchDetail.brnchId}" />
      <input type="hidden" id="regionValue" name="regionValue" value="${branchDetail.regnId}" />
      <aside class="title_line">
        <h2><spring:message code='service.title.General' /></h2>
      </aside>
      <table class="type1">
        <caption>table</caption>
        <colgroup>
          <col style="width: 140px" />
          <col style="width: *" />
          <col style="width: 140px" />
          <col style="width: *" />
        </colgroup>
        <tbody>
          <tr>
            <th scope="row"><spring:message code='service.grid.brchTyp' /><span class="must">**</span></th>
            <td>
              <select id="branchType" name="branchType" class="w100p" disabled="true">
                <%-- <option value="${branchDetail.typeId}"  selected></option> --%>
                <c:forEach var="list" items="${branchType }" varStatus="status">
                  <option value="${list.branchId}">${list.c1}</option>
                </c:forEach>
              </select>
            </td>
            <th scope="row"><spring:message code='service.grid.BranchCode' /><span class="must">**</span></th>
            <td>
              <input type="text" title="" id="branchCd" name="branchCd" placeholder="<spring:message code='service.grid.BranchCode' />" class="w100p readonly" readonly="readonly" value="${branchDetail.code}" />
            </td>
          </tr>
          <tr>
            <th scope="row"><spring:message code='sys.title.branch.name' /><span class="must">**</span></th>
            <td>
              <input type="text" title="" placeholder="<spring:message code='sys.title.branch.name' />" class="w100p" id="branchName" name="branchName" value="${branchDetail.name}" />
            </td>
            <th scope="row"><spring:message code='sal.title.text.region' /></th>
            <td>
              <select id="cmRegion" name="cmRegion" class="w100p">
              </select>
            </td>
          </tr>
        </tbody>
      </table>

      <aside class="title_line">
        <h2><spring:message code='sal.title.address' /></h2>
      </aside>
      <table class="type1">
        <caption>table</caption>
        <colgroup>
          <col style="width: 140px" />
          <col style="width: *" />
          <col style="width: 140px" />
          <col style="width: *" />
        </colgroup>
        <tbody>
          <tr>
            <th scope="row"><spring:message code='sal.title.text.areaSearch' /><span class="must">**</span></th>
            <td colspan="3">
              <input type="text" title="" id="searchSt" name="searchSt" placeholder="" class="" /><a href="#" onclick="fn_addrSearch()" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
            </td>
          </tr>
          <tr>
            <th scope="row"><spring:message code='sal.text.addressDetail' /><span class="must">**</span></th>
            <td colspan="3">
              <input type="text" title="" id="addrDtl" name="addrDtl" placeholder="<spring:message code='sal.text.addressDetail' />" class="w100p" value="${branchDetail.c2}" />
            </td>
          </tr>
          <tr>
            <th scope="row"><spring:message code='sal.text.street' /></th>
            <td colspan="3">
              <input type="text" title="" id="streetDtl" name="streetDtl" placeholder="Detail Address" class="w100p" value="${branchDetail.c3}" />
            </td>
          </tr>
          <tr>
            <th scope="row"><spring:message code='sal.text.area4' /><span class="must">**</span></th>
            <td colspan="3">
              <select class="w100p" id="mArea" name="mArea" onchange="javascript : fn_getAreaId()"></select>
            </td>
          </tr>
          <tr>
            <th scope="row"><spring:message code='sal.text.city2' /><span class="must">**</span></th>
            <td>
              <select class="w100p" id="mCity" name="mCity" onchange="javascript : fn_selectCity(this.value)"></select>
            </td>
            <th scope="row"><spring:message code='sal.text.postCode3' /><span class="must">**</span></th>
            <td>
              <select class="w100p" id="mPostCd" name="mPostCd" onchange="javascript : fn_selectPostCode(this.value)"></select>
            </td>
          </tr>
          <tr>
            <th scope="row"><spring:message code='sal.text.state1' /><span class="must">**</span></th>
            <td>
              <select class="w100p" id="mState" name="mState" onchange="javascript : fn_selectState(this.value)"></select>
            </td>
            <th scope="row"><spring:message code='sys.country' /><span class="must">**</span></th>
            <td>
              <input type="text" title="" id="mCountry" name="mCountry" placeholder="" class="w100p readonly" readonly="readonly" value="Malaysia" />
            </td>
          </tr>
        </tbody>
      </table>

      <aside class="title_line">
        <h2><spring:message code='sal.tap.title.contactInfo' /></h2>
      </aside>
      <table class="type1">
        <caption>table</caption>
        <colgroup>
          <col style="width: 140px" />
          <col style="width: *" />
          <col style="width: 140px" />
          <col style="width: *" />
        </colgroup>
        <tbody>
          <tr>
            <th scope="row"><spring:message code='sales.ContactPerson' /></th>
            <td>
              <input id="contact" name="contact" type="text" title="" placeholder="<spring:message code='sales.ContactPerson' />" class="w100p" value="${branchDetail.c6}" />
            </td>
            <th scope="row"><spring:message code='sal.text.telF' /></th>
            <td>
              <input id="txtFax" name="txtFax" type="text" title="" placeholder="<spring:message code='sal.text.telF' />" class="w100p" value="${branchDetail.c16}" />
            </td>
          </tr>
          <tr>
            <th scope="row"><spring:message code='txtTel1' /></th>
            <td>
              <input id="txtTel1" name="txtTel1" type="text" title="" placeholder="<spring:message code='txtTel1' />" class="w100p" value="${branchDetail.c14}" />
            </td>
            <th scope="row"><spring:message code='txtTel2' /></th>
            <td>
              <input id="txtTel2" name="txtTel2" type="text" title="" placeholder="<spring:message code='txtTel2' />" class="w100p" value="${branchDetail.c15}" />
            </td>
          </tr>
          <tr>
            <th scope="row"><spring:message code='sales.ExpireDate' /></th>
            <td>
              <input id="closingDate" name="closingDate" placeholder="<spring:message code='service.placeHolder.dtFmt' />" class="j_date w100p" type="text" title="" />
            </td>
            <th scope="row"><spring:message code='budget.CostCenter' /><span class="must">**</span></th>
            <td>
              <input id="costCenter" name="costCenter" type="text" title="" placeholder="<spring:message code='budget.CostCenter' />" class="w100p" value="${branchDetail.costCentr}" />
            </td>
          </tr>
        </tbody>
      </table>

      <aside class="title_line"><!-- title_line start -->
        <h2><spring:message code='txtGPS' /></h2>
      </aside>
      <table class="type1">
        <!-- table start -->
        <caption>table</caption>
        <colgroup>
          <col style="width: 110px" />
          <col style="width: *" />
          <col style="width: 110px" />
          <col style="width: *" />
          <col style="width: 60px" />
        </colgroup>
        <tbody>
          <tr>
            <th scope="row"><spring:message code='txtLatitude' /></th>
            <td>
              <input type="text" title="<spring:message code='txtLatitude' />" placeholder="<spring:message code='txtLatitude' />" id="txtLatitude" name="txtLatitude" class="" value="${branchDetail.latitude}" />
            </td>
            <th scope="row"><spring:message code='txtLongtitude' /></th>
            <td style='text-align: center;'>
              <input type="text" title="<spring:message code='txtLongtitude' />" placeholder="<spring:message code='txtLongtitude' />" class="w100p" id="txtLongtitude" name="txtLongtitude" value="${branchDetail.longtitude}" />
            </td>
            <td>
              <a href="#" onclick="fn_searchLocation()" class=""><img src="${pageContext.request.contextPath}/resources/images/common/normal_Location.gif" alt="Location" width="40px" height='40px'/></a>
            </td>
          </tr>
        </tbody>
      </table>
    </form>
    <ul class="center_btns">
      <li><p class="btn_blue2 big"><a href=" javascript:fn_branchSave();"><spring:message code='sys.btn.save' /></a></p></li>
    </ul>
  </section>
</div>