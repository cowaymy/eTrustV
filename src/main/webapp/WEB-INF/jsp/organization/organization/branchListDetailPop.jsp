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
    if ('' != tempState && null != tempState) {
      CommonCombo.make('mState', "/sales/customer/selectMagicAddressComboList", '', tempState, optionState);
    } else {
      CommonCombo.make('mState', "/sales/customer/selectMagicAddressComboList", '', '', optionState);
      fn_selectState('');
      return;
    }

    var cityJson = {
      state : tempState
    };
    if ('' != tempCity && null != tempCity) {

      CommonCombo.make('mCity', "/sales/customer/selectMagicAddressComboList", cityJson, tempCity, optionCity);

    } else {
      CommonCombo.make('mCity', "/sales/customer/selectMagicAddressComboList", cityJson, '', optionCity);

      fn_selectCity('');
      return;
    }

    var postCodeJson = {
      state : tempState,
      city : tempCity
    };
    if ('' != tempPostCode && null != tempPostCode) {
      CommonCombo.make('mPostCd', "/sales/customer/selectMagicAddressComboList", postCodeJson, tempPostCode, optionPostCode);
    } else {
      CommonCombo.make('mPostCd', "/sales/customer/selectMagicAddressComboList", postCodeJson, '', optionPostCode);
      fn_selectPostCode('');
      return;
    }

    var areaJson = {
      state : tempState,
      city : tempCity,
      postcode : tempPostCode
    };
    if ('' != tempArea && null != tempArea) {
      CommonCombo.make('mArea', "/sales/customer/selectMagicAddressComboList", areaJson, tempArea, optionArea);
    } else {
      CommonCombo.make('mArea', "/sales/customer/selectMagicAddressComboList", areaJson, '', optionArea);
      return;
    }

  }

  $(document).ready(function() {
    /* doGetCombo('/common/selectCodeList.do', '49', '','cmRegion', 'S' , ''); //region
    var branchId = "${branchDetail.typeId}";
    var codeId= $("#regionValue").val();
    $("#branchType option[value="+ branchId +"]").attr("selected", true);
    $("#cmRegion option[value="+ codeId + "]").attr("selected", true);
    alert(branchId);
    alert(codeId);
    var tempState = $("#getState").val();
    var tempCity = $("#getCity").val();
    var tempPostCode = $("#getPostCode").val();
    var tempArea = $("#getArea").val();

      alert("ADDR : " + tempState + "       " + tempCity + "         " + tempPostCode + "               " + tempArea );
      fn_updateInitField(tempState, tempCity , tempPostCode , tempArea);

      //$("branchType").val(branchId).attr("selected","selected");
       /* $("#bankSelect  option[value="+bankId     +"]").attr("selected", true);   */
  });

  function fn_branchSave() {
    if (validRequiredField()) {
      Common.ajax("GET", "/organization/branchListUpdate.do", $("#branchForm").serialize(), function(result) {
        Common.alert("<spring:message code='sal.aerlt.msg.saveSuccessful' />");
      });
    } else {
      Common.alert("<spring:message code='sal.msg.failToUpt' />");
    }
  }

  function validRequiredField() {
    var valid = "true";
    var message = "";

    var newBranchName = $("#branchName").val();
    var txtAddress1 = $("#txtAddress1").val();
    var txtAddress2 = $("#txtAddress2").val();
    var txtAddress3 = $("#txtAddress3").val();
    var nation = $("#nation").val();
    var state = $("#state").val();
    var area = $("#area").val();
    var postcode = $("#postcode").val();
    var contact = $("#contact").val();
    var txtFax = $("#txtFax").val();
    var txtTel1 = $("#txtTel1").val();
    var txtTel2 = $("#txtTel2").val();

    if ($("#branchType").val() <= -1) {
      valid = false;
      message += "* Please select the branch type.<br />";
    }

    if (newBranchName == "") {
      valid = false;
      message += "* Please key in the branch name.<br />";
    } else {
      if (newBranchName.length > 50) {
        valid = false;
        message += "* Branch name cannot exceed 50 characters.<br />";
      }
    }

    if ($.trim(txtAddress1) != "") {
      if (txtAddress1.length > 50) {
        valid = false;
        message += "* Address (1) cannot exceed 50 characters.<br />";
      }
    }

    if ($.trim(txtAddress2) != "") {
      if (txtAddress2.length > 50) {
        valid = false;
        message += "* Address (2) cannot exceed 50 characters.<br />";
      }
    }

    if ($.trim(txtAddress3) != "") {
      if (txtAddress3.length > 50) {
        valid = false;
        message += "* Address (2) cannot exceed 50 characters.<br />";
      }
    }

    if (nation == "1") {
      if (state <= -1) {
        valid = false;
        message += "* Please select the state.<br />";
      }
      if (area <= -1) {
        valid = false;
        message += "* Please select the area.<br />";
      }

      if (postcode <= -1) {
        valid = false;
        message += "* Please select the postcode.<br />";
      }
    }

    if ($("#addrDtl").val() == '') {
      label = "<spring:message code='sal.text.addressDetail' />";
      Common.alert("<spring:message code='sys.msg.necessary' arguments='" + label + "' htmlEscape='false'/>");
      return false;
    }

    if ($("#mArea").val() == '') {
      label = "<spring:message code='sal.text.area4' />";
      Common.alert("<spring:message code='sys.msg.necessary' arguments='" + label + "' htmlEscape='false'/>");
      return false;
    }

    if ($("#mCity").val() == '') {
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

    if ($.trim(contact) != "") {
      if (contact.length > 50) {
        valid = false;
        message += "* Contact person cannot exceed 50 characters.<br />";
      }
    }

    if ($.trim(txtFax) != "") {
      if (txtFax.length > 15) {
        valid = false;
        message += "* Tel (F) cannot exceed 15 characters.<br />";
      }
    }

    if ($.trim(txtTel1) != "") {
      if (txtTel1.length > 15) {
        valid = false;
        message += "* Tel (1) cannot exceed 15 characters.<br />";
      }
    }

    if ($.trim(txtTel2) != "") {
      if (txtTel2.length > 15) {
        valid = false;
        message += "* Tel (2) cannot exceed 15 characters.<br />";
      }
    }

    if (!valid)
      alert(message + "</b> Add Branch Summary");
    return valid;
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

  function fn_searchLocation(){
    var location = [{"lattitude": $('#lblViewLatitude').text(), "longtitude": $('#lblViewLongtitude').text()}];

    var prm = { "coordinate" : JSON.stringify(location),
                     "callFunc" : "1"};
    Common.popupDiv("/common/mapPop.do", prm , null, true, '_searchDiv');
  }
</script>
<div id="popup_wrap" class="popup_wrap">
  <header class="pop_header">
    <h1><spring:message code='txtBranchMgnmt' /> - <spring:message code='sys.btn.view' /></h1>
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
              <span><c:out value="${branchDetail.codeName}" /></span>
            </td>
            <th scope="row"><spring:message code='service.grid.BranchCode' /><span class="must">**</span></th>
            <td>
              <span><c:out value="${branchDetail.code}" /></span>
            </td>
          </tr>
          <tr>
            <th scope="row"><spring:message code='sys.title.branch.name' /><span class="must">**</span></th>
            <td>
              <span><c:out value="${branchDetail.name}" /></span>
            </td>
            <th scope="row"><spring:message code='sal.title.text.region' /></th>
            <td>
              <span><c:out value="${branchDetail.c11}" /></span>
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
            <th scope="row"><spring:message code='sal.text.addressDetail' /><span class="must">**</span></th>
            <td colspan="3">
              <span><c:out value="${branchDetail.c2}" /></span>
            </td>
          </tr>
          <tr>
            <th scope="row"><spring:message code='sal.text.street' /></th>
            <td colspan="3">
              <span><c:out value="${branchDetail.c3}" /></span>
            </td>
          </tr>
          <tr>
            <th scope="row"><spring:message code='sal.text.area4' /><span class="must">**</span></th>
            <td colspan="3">
              <span><c:out value="${branchAddr.area}" /></span>
            </td>
          </tr>
          <tr>
            <th scope="row"><spring:message code='sal.text.city2' /><span class="must">**</span></th>
            <td>
              <span><c:out value="${branchAddr.city}" /></span>
            </td>
            <th scope="row"><spring:message code='sal.text.postCode3' /><span class="must">**</span></th>
            <td>
              <span><c:out value="${branchAddr.postcode}" /></span>
            </td>
          </tr>
          <tr>
            <th scope="row"><spring:message code='sal.text.state1' /><span class="must">**</span></th>
            <td>
              <span><c:out value="${branchAddr.state}" /></span>
            </td>
            <th scope="row"><spring:message code='sys.country' /><span class="must">**</span></th>
            <td>
              <span><c:out value="${branchAddr.country}" /></span>
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
            <th scope="row">Contact Person</th>
            <td>
              <span><c:out value="${branchDetail.c6}" /></span>
            </td>
            <th scope="row">Tel (F)</th>
            <td>
              <span><c:out value="${branchDetail.c16}" /></span>
            </td>
          </tr>
          <tr>
            <th scope="row">Tel (1)</th>
            <td>
              <span><c:out value="${branchDetail.c14}" /></span>
            </td>
            <th scope="row">Tel (2)</th>
            <td>
              <span><c:out value="${branchDetail.c15}" /></span>
            </td>
          </tr>
        </tbody>
      </table>

      <aside class="title_line">
        <h2>Other</h2>
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
            <th scope="row">Cost Center</th>
            <td colspan="3">
              <span><c:out value="${branchDetail.costCentr}" /></span>
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
              <span id='lblViewLatitude'><c:out value="${branchDetail.latitude}" /></span>
            </td>
            <th scope="row"><spring:message code='txtLongtitude' /></th>
            <td>
              <span id='lblViewLongtitude'><c:out value="${branchDetail.longtitude}" /></span>
            </td>
            <td>
              <a href="#" onclick="fn_searchLocation()" class=""><img src="${pageContext.request.contextPath}/resources/images/common/normal_Location.gif" alt="Location" width="40px" height='40px'/></a>
            </td>
          </tr>
        </tbody>
      </table>
    </form>
  </section>
</div>