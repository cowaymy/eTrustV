<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<style>
</style>
<script type="text/javaScript">
  //AUIGrid 그리드 객체
  var myGridID;
  var excelListGridID;
  var option = {
    width : "1200px", // 창 가로 크기
    height : "500px" // 창 세로 크기
  };

  var basicAuth = false;
  var failReasonList = f_getTtype();

  $(document).ready(function() {
    //Branch Combo
    doGetComboSepa('/common/selectBranchCodeList.do', '4', ' - ', '', 'branchId', 'M', 'f_multiCombo');
    doGetCombo('/common/selectCodeList.do', '49', '', 'region', 'M', 'f_multiCombo'); //region
    doGetCombo('/common/selectCodeList.do', '115', '', 'cardTypeId', 'M', 'f_multiCombo'); //card type
    doGetCombo('/common/selectCodeList.do', '8', '', 'custTypeId', 'M', 'f_multiCombo'); //cust type
    f_multiCombo();
    loadMemberInfo();

    createAUIGrid();
    createExcelAUIGrid();
    AUIGrid.bind(myGridID, "cellDoubleClick", function(event) {
      fn_setDetail(myGridID, event.rowIndex);
    });

    AUIGrid.bind(myGridID, "cellEditBegin", function(event){
    	if(event.item.statusDesc == "Rejected"){
    		return true;
    	}
    	return false;
    });

    //Search
    $("#_listSearchBtn").click(function() {

      var requestDateFrom = $('#requestDateFrom').val();
      var requestDateTo = $('#requestDateFrom').val();
      var requestTimeFrom = $('#requestTimeFrom').val();
      var requestTimeTo = $('#requestTimeTo').val();

      if ((requestTimeFrom == null || requestTimeFrom == "") && (requestTimeTo == null || requestTimeTo == "")) {
      } else {
        if (requestDateFrom == null || requestDateFrom == "" || requestDateTo == null || requestDateTo == "") {
          Common.alert("Request Date is required for Time filtering");
          return false;
        }
      }
      //Validation start
      selectList();
    });

    $('#_memBtn').click(function() {
      //Common.searchpopupWin("searchForm", "/common/memberPop.do","");
      Common.popupDiv("/common/memberPop.do", $("#searchForm").serializeJSON(), null, true);
    });
    $('#_memCode').change(function(event) {
      var memCd = $('#_memCode').val().trim();

      if (FormUtil.isNotEmpty(memCd)) {
        fn_loadOrderSalesman(null, memCd);
      } else {
        $('#_memId').val('');
        $('#_memName').val('');
      }
    });
    $('#_memCode').keydown(function(event) {
      if (event.which === 13) { //enter
        var memCd = $('#_memCode').val().trim();

        if (FormUtil.isNotEmpty(memCd)) {
          fn_loadOrderSalesman(null, memCd);
        } else {
          $('#_memId').val('');
          $('#_memName').val('');
        }
        return false;
      }
    });

    //Excel Download
    $('#excelDown').click(function() {
      var excelProps = {
        fileName : "Auto Debit Enroll List",
        exceptColumnFields : AUIGrid.getHiddenColumnDataFields(excelListGridID)
      };
      AUIGrid.exportToXlsx(excelListGridID, excelProps);
    });

    $('#updateFailReason').click(function(event){
    	event.preventDefault();
    	if(GridCommon.getEditData(myGridID).update.length){
    	       Common.confirm("<spring:message code='sys.common.alert.save'/>",function(e){
    	             Common.showLoader();
    	             fetch("/payment/mobileautodebit/updateFailReason.do",{
    	                 method: "POST",
    	                 headers : {
    	                     "Content-Type": "application/json",
    	                 },
    	                 body : JSON.stringify(GridCommon.getEditData(myGridID))
    	             })
    	             .then(r=>r.json())
    	             .then(data=>{
    	                 Common.removeLoader();
    	                 Common.alert(data.message,selectList)
    	             })
    	         });
    	}else{
    		Common.alert('No data selected.');
    		return;
    	}
    });

    $('#memTyp').change(function() {
      if ($('#memTyp').val().trim() == 'CD') {
        doGetComboSepa('/common/selectBranchCodeList.do', '4', ' - ', '', 'branchId', 'M', 'f_multiCombo');
      } else {
        doGetComboSepa('/common/selectBranchCodeList.do', '48', ' - ', '', 'branchId', 'M', 'f_multiCombo');
      }
    });
  });

  function fn_loadOrderSalesman(memId, memCode) {

    Common.ajax("GET", "/sales/order/selectMemberByMemberIDCode.do", {
      memId : memId,
      memCode : memCode
    }, function(memInfo) {

      if (memInfo == null) {
        if (memId != "" || memId != null) {
          Common.alert('<b>Member not found.</br>Your input member id : ' + memId + '</b>');
        } else {
          Common.alert('<b>Member not found.</br>Your input member code : ' + memCode + '</b>');
        }
      } else {
        $('#_memId').val(memInfo.memId);
        $('#_memCode').val(memInfo.memCode);
        $('#_memName').val(memInfo.name);
      }
    });
  }

  function f_multiCombo() {
    $('#region').change(function() {
    }).multipleSelect({
      selectAll : true,
      width : '80%'
    });
    $('#branchId').change(function() {
    }).multipleSelect({
      selectAll : true,
      width : '100%'
    });
    $('#cardTypeId').change(function() {
    }).multipleSelect({
      selectAll : true,
      width : '100%'
    });
    $('#custTypeId').change(function() {
    }).multipleSelect({
      selectAll : true,
      width : '100%'
    });
    $('#status').change(function() {
    }).multipleSelect({
      selectAll : true,
      width : '100%'
    });
  }

  function createAUIGrid() {
    var columnLayout = [
        {
          dataField : "padId",
          headerText : 'PAD ID.',
          editable : false,
          visible : false
        }, {
          dataField : "custCrcId",
          headerText : 'Credit Card Id',
          editable : false,
          visible : false
        }, {
          dataField : "padNo",
          headerText : 'PAD No.',
          width : '8%',
          editable : false
        }, {
          dataField : "keyInDate",
          headerText : 'PAD Key-in at',
          width : '8%',
          editable : false
        }, {
          dataField : "statusDesc",
          headerText : 'Status',
          width : '6%',
          editable : false
        }, {
          dataField : "salesOrdNo",
          headerText : 'Order Number',
          width : '6%',
          editable : false
        }, {
          dataField : "custName",
          headerText : 'Customer Name',
          width : '8%',
          editable : false
        }, {
          dataField : "creator",
          headerText : 'Creator',
          width : '8%',
          editable : false
        }, {
          dataField : "userBranch",
          headerText : 'User Branch',
          width : '8%',
          editable : false
        }, {
          dataField : "ordOtstndMth",
          headerText : 'Outstanding Month',
          width : '5%',
          editable : false
        },
        {dataField: "resnDesc",
          headerText :"Fail Reason" ,
          width : '10%',
          labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
                var retStr = "";

                for(var i=0,len=failReasonList.length; i<len; i++) {
                    if(failReasonList[i]["code"] == value) {
                        retStr = failReasonList[i]["codeName"];
                        break;
                    }
                }
                return retStr == "" ? value : retStr;
            },
            editRenderer :
            {
               type : "ComboBoxRenderer",
               showEditorBtnOver : false, // 마우스 오버 시 에디터버턴 보이기
               list : failReasonList,
               keyField : "code",
               valueField : "codeName"
            }
        },
        {
          dataField : "remarks",
          headerText : 'Fail Remark',
          width : '10%',
          editable : false
        }, {
          dataField : "lastUpdatedDate",
          headerText : 'Last Update At(By)',
          width : '8%',
          editable : false,
          labelFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
            var formatString = "";
            var valueArray = value.split(",");
            if (valueArray.length > 0) {
              for (var i = 0; i < valueArray.length; i++) {
                if (i == 1) {
                  if (valueArray[i].length > 0) {
                    formatString = formatString + " (" + valueArray[i] + ")";
                  }
                } else {
                  formatString = formatString + valueArray[i] + "\n";
                }
              }
            }
            return formatString;
          }
        },{
            dataField : "custMobile",
            headerText : 'SMS Contact',
            width : '8%',
            editable : false,
            labelFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
            	return  value.substr(0,3) + value.substr(3,value.length-7).replace(/[0-9]/g, "*") + value.substr(-4);
            }
     },{
           dataField : "custEmail",
           headerText : 'Email Address',
           width : '8%',
           editable : false,
           labelFunction : function(rowIndex, columnIndex, value){
               let maskedEmail = "" , prefix= value.substr(0, value.lastIndexOf("@")), postfix= value.substr(value.lastIndexOf("@"));

               for(let i=0; i<prefix.length; i++){
                   if(i == 0 || i == prefix.length - 1) {
                       maskedEmail = maskedEmail + prefix[i].toString();
                   }
                   else {
                       maskedEmail = maskedEmail + "*";
                   }
               }
               return maskedEmail =maskedEmail +postfix;
           }
     }];

    var gridPros = {
      usePaging : true,
      pageRowCount : 20,
      editable : true,
      fixedColumnCount : 3,
      showStateColumn : false,
      displayTreeOpen : true,
      headerHeight : 30,
      useGroupingPanel : false,
      skipReadonlyColumns : true,
      wrapSelectionMove : true,
      showRowNumColumn : true,
      wordWrap : true,
      height : 450
    };
    myGridID = AUIGrid.create("#grid_wrap", columnLayout, gridPros);
  }

  //ajax list 조회.
  function selectList() {
    Common.ajax("GET", "/payment/mobileautodebit/selectAutoDebitEnrollmentList", $("#searchForm").serialize(), function(result) {
      AUIGrid.setGridData(myGridID, result);
      AUIGrid.setGridData(excelListGridID, result);
    });
  }

  function fn_setDetail(gridID, rowIdx) {
    var padidvalue = AUIGrid.getCellValue(gridID, rowIdx, "padId");
    var salesOrdNo = AUIGrid.getCellValue(gridID, rowIdx, "salesOrdNo");
    var custCrcId = AUIGrid.getCellValue(gridID, rowIdx, "custCrcId");
    var authFuncChange = "${PAGE_AUTH.funcChange}";
    Common.popupDiv("/payment/mobileautodebit/autoDebitDetailPop.do", {
      padId : AUIGrid.getCellValue(gridID, rowIdx, "padId"),
      salesOrdNo : AUIGrid.getCellValue(gridID, rowIdx, "salesOrdNo"),
      custCrcId : AUIGrid.getCellValue(gridID, rowIdx, "custCrcId"),
      authFuncChange : authFuncChange
    }, null, true, "_divAutoDebitDetailPop");
  }

  function createExcelAUIGrid() {
    //AUIGrid 칼럼 설정
    var excelColumnLayout = [
        {
          dataField : "padId",
          headerText : 'PAD ID.',
          width : 140,
          editable : false,
          visible : false
        }, {
          dataField : "custCrcId",
          headerText : 'Credit Card Id',
          width : 140,
          editable : false,
          visible : false
        }, {
          dataField : "padNo",
          headerText : 'PAD No.',
          width : 140,
          editable : false
        }, {
          dataField : "keyInDate",
          headerText : 'PAD Key-in Date',
          width : 160,
          editable : false
        }, {
          dataField : "statusDesc",
          headerText : 'Status',
          width : 150,
          editable : false
        }, {
          dataField : "salesOrdNo",
          headerText : 'Order Number',
          width : 170,
          editable : false
        }, {
          dataField : "custName",
          headerText : 'Customer Name',
          width : 170,
          editable : false
        }, {
          dataField : "creator",
          headerText : 'Creator',
          width : 170,
          editable : false
        }, {
          dataField : "userBranch",
          headerText : 'User Branch',
          width : 170,
          editable : false
        }, {
          dataField : "ordOtstndMth",
          headerText : 'Outstanding Month',
          width : 170,
          editable : false
        },{
          dataField : "resnDesc",
          headerText : 'Fail Reason',
          width : 170,
          editable : false
        }, {
          dataField : "remarks",
          headerText : 'Fail Remark',
          width : 170,
          editable : false
        }, {
          dataField : "lastUpdatedDate",
          headerText : 'Last Update At(By)',
          width : 170,
          editable : false,
          labelFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
            var formatString = "";
            var valueArray = value.split(",");

            if (valueArray.length > 0) {
              for (var i = 0; i < valueArray.length; i++) {
                if (i == 1) {
                  formatString = formatString + "(" + valueArray[i] + ")";
                } else {
                  formatString = formatString + valueArray[i] + "\n";
                }
              }
            }
            return formatString;
          }
     },{
            dataField : "custMobile",
            headerText : 'SMS Contact',
            width : 170,
            editable : false
     },{
           dataField : "custEmail",
           headerText : 'Email Address',
           width : 170,
           editable : false
     }];

    //그리드 속성 설정
    var excelGridPros = {
      enterKeyColumnBase : true,
      useContextMenu : true,
      enableFilter : true,
      showStateColumn : true,
      displayTreeOpen : true,
      noDataMessage : "<spring:message code='sys.info.grid.noDataMessage' />",
      groupingMessage : "<spring:message code='sys.info.grid.groupingMessage' />",
      exportURL : "/common/exportGrid.do"
    };

    excelListGridID = GridCommon.createAUIGrid("excel_list_grid_wrap", excelColumnLayout, "", excelGridPros);

  }

  function fn_clear() {
    $('#padNo').val('');
    $('#requestDateFrom').val('');
    $('#requestDateTo').val('');
    $('#orderNo').val('');

    $('#status').multipleSelect("uncheckAll");
    $('#branchId').multipleSelect("uncheckAll");
    $('#region').multipleSelect("uncheckAll");
    $('#cardTypeId').multipleSelect("uncheckAll");
    $('#custTypeId').multipleSelect("uncheckAll");

    $('#requestTimeFrom').val('');
    $('#requestTimeTo').val('');
    $('#_memId').val('');
    $('#_memCode').val('');
    $('#_memName').val('');
    $('#nricCompanyNo').val('');
    $('#orgCode').val('');
    $('#grpCode').val('');
    $('#deptCode').val('');
    $('#memTyp').val('');
    loadMemberInfo();
  }

  function loadMemberInfo(){
    if("${SESSION_INFO.memberLevel}" =="1"){

        $("#orgCode").val("${orgCode}");
        $("#orgCode").attr("class", "w100p readonly");
        $("#orgCode").attr("readonly", "readonly");

    }else if("${SESSION_INFO.memberLevel}" =="2"){
        $("#orgCode").val("${orgCode}");
        $("#orgCode").attr("class", "w100p readonly");
        $("#orgCode").attr("readonly", "readonly");

        $("#grpCode").val("${grpCode}");
        $("#grpCode").attr("class", "w100p readonly");
        $("#grpCode").attr("readonly", "readonly");

    }else if("${SESSION_INFO.memberLevel}" =="3"){

        $("#orgCode").val("${orgCode}");
        $("#orgCode").attr("class", "w100p readonly");
        $("#orgCode").attr("readonly", "readonly");

        $("#grpCode").val("${grpCode}");
        $("#grpCode").attr("class", "w100p readonly");
        $("#grpCode").attr("readonly", "readonly");

        $("#deptCode").val("${deptCode}");
        $("#deptCode").attr("class", "w100p readonly");
        $("#deptCode").attr("readonly", "readonly");

    }else if("${SESSION_INFO.memberLevel}" =="4"){

        $("#orgCode").val("${orgCode}");
        $("#orgCode").attr("class", "w100p readonly");
        $("#orgCode").attr("readonly", "readonly");

        $("#grpCode").val("${grpCode}");
        $("#grpCode").attr("class", "w100p readonly");
        $("#grpCode").attr("readonly", "readonly");

        $("#deptCode").val("${deptCode}");
        $("#deptCode").attr("class", "w100p readonly");
        $("#deptCode").attr("readonly", "readonly");
    }
  }

  function f_getTtype() {
      var rData = new Array();
      $.ajax({
          type : "GET",
          url : "/payment/mobileautodebit/selectRejectReasonCodeOption.do",
          dataType : "json",
          contentType : "application/json;charset=UTF-8",
          async : false,
          success : function(data) {
              $.each(data, function(index, value) {
                  var list = new Object();
                  list.code = data[index].code;
                  list.codeId = data[index].codeId;
                  list.codeName = data[index].codeName;
                  rData.push(list);
              });
          },
          error : function(jqXHR, textStatus, errorThrown) {
              Common.alert("Draw ComboBox['" + obj + "'] is failed. \n\n Please try again.");
          },
          complete : function() {
          }
      });

      return rData;
  }
</script>
<!-- html content -->
<section id="content">
  <ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
  </ul>
  <!-- title_line start -->
  <aside class="title_line">
    <p class="fav"><a href="#" class="click_add_on"><spring:message code='pay.text.myMenu' /></a></p>
    <h2>Auto Debit Enroll List</h2>
    <ul class="right_btns">
      <c:if test="${PAGE_AUTH.funcView == 'Y'}">
        <li><p class="btn_blue"><a id="_listSearchBtn" href="#"><span class="search"></span>
            <spring:message code='sys.btn.search' /></a></p></li>
      </c:if>
      <li><p class="btn_blue"><a href="#" onclick="fn_clear();"><span class="clear"></span>
          <spring:message code='sys.btn.clear' /></a></p></li>
    </ul>
  </aside>
  <!-- title_line end -->
  <!-- search_table start -->
  <section class="search_table">
    <form id="searchForm" action="#" method="post">
      <table class="type1">
        <caption>table</caption>
        <colgroup>
          <col style="width: 170px" />
          <col style="width: *" />
          <col style="width: 230px" />
          <col style="width: *" />
          <col style="width: 160px" />
          <col style="width: *" />
        </colgroup>
        <tbody>
          <tr>
            <th scope="row">PAD No</th>
            <td>
              <input type="text" title="PAD No" id="padNo" name="padNo" placeholder="PAD No" class="w100p" />
            </td>
            <th scope="row">Request Date</th>
            <td>
              <!-- date_set start -->
              <div class="date_set w100p">
                <p><input id="requestDateFrom" name="requestDateFrom" type="text" title="Request Start Date" placeholder="DD/MM/YYYY" class="j_date" autocomplete="off" /></p> <span>~</span>
                <p><input id="requestDateTo" name="requestDateTo" type="text" title="Request End Date" placeholder="DD/MM/YYYY" class="j_date" autocomplete="off" /></p>
              </div>
              <!-- date_set end -->
            </td>
            <th scope="row">Order No</th>
            <td>
              <input type="text" title="Order No" id="orderNo" name="orderNo" placeholder="Order No" class="w100p" />
            </td>
          </tr>
          <tr>
            <th scope="row">Status</th>
            <td>
              <select id="status" name="status" class="w100p multy_select" multiple="multiple">
                <option value="1">Active</option>
                <option value="5">Approved</option>
                <option value="6">Rejected</option>
              </select>
            </td>
            <th scope="row">Posting Branch</th>
            <td>
              <select id="branchId" name="branchId" class="multy_select w100p" multiple="multiple"></select>
            </td>
            <th scope="row"><spring:message code='sal.title.text.region' /></th>
            <td>
              <select id="region" name="region" class="multy_select w100p" multiple="multiple">
              </select>
            </td>
          </tr>
          <tr>
            <th scope="row">Card Type</th>
            <td>
              <select id="cardTypeId" name="cardTypeId" class="multy_select w100p" multiple="multiple"></select>
            </td>
            <th scope="row">Time</th>
            <td>
              <div class="date_set w100p">
                <p><input id="requestTimeFrom" name="requestTimeFrom" type="text" value="" title="" placeholder="24HH Format" class="w100p" maxlength="4" min="0000" max="2300" pattern="\d{4}" /></p> <span>~</span>
                <p><input id="requestTimeTo" name="requestTimeTo" type="text" value="" title="" placeholder="24HH Format" class="w100p" maxlength="4" min="0000" max="2300" pattern="\d{4}" /></p>
              </div>
            </td>
            <th scope="row">Salesman Code</th>
            <td>
              <input id="_memId" name="memId" type="hidden" />
              <p><input id="_memCode" name="memCode" type="text" title="" placeholder="" style="width: 80px;" class="" /></p>
              <p><a id="_memBtn" href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a></p>
              <p><input id="_memName" name="memName" type="text" title="" placeholder="" style="width: 90px;" class="readonly" readonly /></p>
            </td>
          </tr>
          <tr>
            <th scope="row">Customer Type</th>
            <td>
              <select id="custTypeId" name="custTypeId" class="w100p multy_select" multiple="multiple">
              </select>
            </td>
            <th scope="row">Customer Name</th>
            <td>
              <input type="text" title="Customer Name" id="custName" name="custName" placeholder="Customer Name" class="w100p" />
            </td>
            <th scope="row">NRIC/Company No</th>
            <td>
              <input type="text" title="NRIC/Company No" id="nricCompanyNo" name="nricCompanyNo" placeholder="NRIC/Company No" class="w100p" />
            </td>
          </tr>
          <tr>
            <th scope="row">Org Code</th>
            <td>
              <input type="text" title="Org Code" id="orgCode" name="orgCode" placeholder="Org Code" class="w100p" />
            </td>
            <th scope="row">Group Code</th>
            <td>
              <input type="text" title="Grp Code" id="grpCode" name="grpCode" placeholder="Grp Code" class="w100p" />
            </td>
            <th scope="row">Dept Code</th>
            <td>
              <input type="text" title="Dept Code" id="deptCode" name="deptCode" placeholder="Dept Code" class="w100p" />
            </td>
          </tr>
          <tr>
            <th scope="row">Member Type</th>
            <td>
              <select id="memTyp" name="memTyp" class="w100p">
                <option value="">Choose One</option>
                <option value="CD" selected>CD</option>
                <option value="HT">HT</option>
              </select>
            </td>
            <th scope="row">Outstanding Month</th>
            <td>
              <select id="outstandingMth" name="outstandingMth" class="w100p">
                <option value="999">Choose One</option>
                <option value="0">0</option>
                <option value="1">1</option>
                <option value="2">2</option>
                <option value="3">3</option>
                <option value="4">4</option>
              </select>
            </td>
            <th scope="row"></th>
            <td>
            </td>
          </tr>
        </tbody>
      </table>
    </form>
  </section>
  <ul class="right_btns">
   <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
    <li><p class="btn_grid"><a href="#" id="updateFailReason">Update Fail Reason</a></p></li>
    </c:if>
    <li><p class="btn_grid"><a href="#" id="excelDown">Download</a></p></li>
  </ul>
  <!-- search_table end -->
  <!-- search_result start -->
  <section class="search_result">
    <!-- grid_wrap start -->
    <article class="grid_wrap">
      <!-- grid_wrap start -->
      <div id="grid_wrap"></div>
      <div id="excel_list_grid_wrap" style="display: none;"></div>
    </article>
    <!-- grid_wrap end -->
    <!-- grid_wrap end -->
  </section>
  <!-- search_result end -->
</section>
<!-- html content -->