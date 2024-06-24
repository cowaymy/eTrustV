<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">
  document.write('<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/homecare-js-1.0.js?v='+ new Date().getTime() + '"><\/script>');

  var tagGridID;
  //var posItmDetailGridID;
  var excelListGridID;
  var MEM_TYPE = '${SESSION_INFO.userTypeId}';

  //Ajax async
  var ajaxOtp = {
    async : false
  };

  $(document).ready(function() {

            createAUIGrid();
            createExcelAUIGrid();
            girdHide();

            setTimeout(function() {
            	fn_descCheck(0)
              }, 1000);


            if (MEM_TYPE == "1" || MEM_TYPE == "2"
                || MEM_TYPE == "7") {

              if ("${SESSION_INFO.memberLevel}" == "1") {

                $("#orgCode").val("${orgCode}");
                $("#orgCode").attr("class", "w100p readonly");
                $("#orgCode").attr("readonly", "readonly");

              } else if ("${SESSION_INFO.memberLevel}" == "2") {

                $("#orgCode").val("${orgCode}");
                $("#orgCode").attr("class", "w100p readonly");
                $("#orgCode").attr("readonly", "readonly");

                $("#grpCode").val("${grpCode}");
                $("#grpCode").attr("class", "w100p readonly");
                $("#grpCode").attr("readonly", "readonly");

              } else if ("${SESSION_INFO.memberLevel}" == "3") {

                $("#orgCode").val("${orgCode}");
                $("#orgCode").attr("class", "w100p readonly");
                $("#orgCode").attr("readonly", "readonly");

                $("#grpCode").val("${grpCode}");
                $("#grpCode").attr("class", "w100p readonly");
                $("#grpCode").attr("readonly", "readonly");

                $("#deptCode").val("${deptCode}");
                $("#deptCode").attr("class", "w100p readonly");
                $("#deptCode").attr("readonly", "readonly");

              } else if ("${SESSION_INFO.memberLevel}" == "4") {

                $("#orgCode").val("${orgCode}");
                $("#orgCode").attr("class", "w100p readonly");
                $("#orgCode").attr("readonly", "readonly");

                $("#grpCode").val("${grpCode}");
                $("#grpCode").attr("class", "w100p readonly");
                $("#grpCode").attr("readonly", "readonly");

                $("#deptCode").val("${deptCode}");
                $("#deptCode").attr("class", "w100p readonly");
                $("#deptCode").attr("readonly", "readonly");

                $("#salesmanCd").val("${SESSION_INFO.userName}");
                $("#salesmanPopNm").val("${SESSION_INFO.userFullname}");
                $("#salesmanCd").attr("class", "w100p readonly");
                $("#salesmanCd").attr("readonly", "readonly");
                $("#_memBtn").hide();

              }
            }

            /*######################## Init Combo Box ########################*/

            //excel Download
            $('#excelDown')
                .click(
                    function() {
                      var excelProps = {
                        fileName : "Supplement Management",
                        exceptColumnFields : AUIGrid
                            .getHiddenColumnDataFields(excelListGridID)
                      };
                      AUIGrid
                          .exportToXlsx(
                              excelListGridID,
                              excelProps);
                    });

            //Member Search Popup
            $('#memBtn').click(
                function() {
                  Common.popupDiv("/common/memberPop.do", $(
                      "#searchForm").serializeJSON(),
                      null, true);
                });

            $('#salesmanCd').change(function(event) {

              var memCd = $('#salesmanCd').val().trim();

              if (FormUtil.isNotEmpty(memCd)) {
                fn_loadOrderSalesman(0, memCd);
              }
            });

            $('#salesmanPopNm').change(function(event) {

              var memName = $('#salesmanPopNm').val().trim();

              if (FormUtil.isNotEmpty(memName)) {
                fn_loadOrderSalesman(0, memName);
              }
            });

            //Search
            $("#_search").click(function() {

                      //console.log("_supRefNo 111::"+ $("#_supRefNo").val());

                     /*  if ($("#_supRefNo").val() == '') {
                        if ($("#_sDate").val() == '' || $("#_eDate").val() == '') {
                          Common.alert('Reference Date is required when Reference Order No. is empty.')
                          return;
                        } else if ($("#_sDate").val() != '' && $("#_eDate").val() != '') {
                          if (!js.date.checkDateRange( $("#_sDate").val(), $("#_eDate").val(),"Supplement Reference Date", "1")) {
                            console.log("not within date rage");
                          }
                        }
                      } */

                      //Grid Clear
                      AUIGrid.clearGridData(tagGridID);
                      //AUIGrid.clearGridData(posItmDetailGridID);
                      console.log ("into fn_getPosListAjax..")
                      fn_getPosListAjax();
                      console.log ("into fn_getPosListAjax.. done")
                    });

            $("#_new").click(function() {
                Common.popupDiv("/supplement/newTagRequestPop.do", '', null , true , '_insDiv');
            });

            //Update Shipment Tracking
            $("#_update").click(function() {

            	var clickChk = AUIGrid.getSelectedItems(tagGridID);
                      console.log ("clickChk.length:: " + clickChk.length);

                      //Validation
                      if (clickChk == null  || clickChk.length <= 0) {
                        Common.alert('<spring:message code="sal.alert.msg.noOrderSelected" />');
                        return;
                      }

                      var supplementForm = {
                        supRefId : clickChk[0].item.supRefId,
                      //  supRefStus : clickChk[0].item.supRefStus,
                      //  supRefStg : clickChk[0].item.supRefStg,
                        ind : "1"
                      };

                      var supRefId = clickChk[0].item.supRefId;
                     // var supRefStusId = clickChk[0].item.supRefStusId;
                     // var supRefStgId = clickChk[0].item.supRefStgId;

                      console.log ("supplementForm supRefId:: "+ supRefId);
                   //   console.log ("supplementForm supRefStusId:: " + supRefStusId);
                   //   console.log ("supplementForm supRefStgId:: " + supRefStgId);

                      Common.popupDiv("/supplement/tagMngApprovalPop.do",supplementForm,null, true, '_insDiv');

                     /*  if (supRefStusId != 1 || supRefStgId != 3) {
                     // if (supRefStusId == 1 && supRefStgId == 3) {
                    	//Common.popupDiv("/supplement/supplementTrackNoPop.do", {salesOrderId : AUIGrid.getCellValue(gridID, rowIdx, "ordId") }, null , true , '_insDiv');
                    	//Common.popupDiv("/supplement/supplementTrackNoPop.do",supplementForm,null, true, '_insDiv');  tagMngApprovalPop.do
                        Common.popupDiv("/supplement/tagMngApprovalPop.do",supplementForm,null, true, '_insDiv');
                      }else {
                    	   Common.alert('Either order status is not Active or Stage Status is not in Tracking Number and GI/GR Process Pending.');
                    	   return;
                    	  } */
                    });

          //Cell Click Event
            AUIGrid.bind(tagGridID, "cellClick", function(event) {

               console.log("click cell>>>");

              //clear data
              //AUIGrid.clearGridData(posItmDetailGridID);

              console.log("supRefId :: " + event.item.supRefId);
              console.log("supRefNo :: " + event.item.supRefNo);

              var detailParam = {supRefNo : event.item.supRefNo};
              var detailParam = {supRefId : event.item.supRefId};

              //Ajax
/*                Common.ajax("GET","/supplement/getSupplementDetailList",detailParam, function(result) {
                    AUIGrid.setGridData(posItmDetailGridID,result);
                    AUIGrid.setGridData(excelListGridID,result);
                  }); */
            });

          });//Doc ready Func End ****************************************************************************************************************************************

  function fn_multiComboBranch() {
    if ($("#_brnchId option[value='${SESSION_INFO.userBranchId}']").val() === undefined) {
      $('#_brnchId').change(function() {
        console.log($(this).val());
      }).multipleSelect({
        selectAll : true, // 전체선택
        width : '100%'
      }).multipleSelect("enable");
      //   $('#_brnchId').multipleSelect("checkAll");
    } else {
      if ('${PAGE_AUTH.funcUserDefine2}' == "Y") {
        $('#_brnchId').change(function() {
          console.log($(this).val());
        }).multipleSelect({
          selectAll : true, // 전체선택
          width : '100%'
        }).multipleSelect("enable");
        //   $('#_brnchId').multipleSelect("checkAll");
      } else {
        $('#_brnchId').change(function() {
          console.log($(this).val());
        }).multipleSelect({
          selectAll : true, // 전체선택
          width : '100%'
        }).multipleSelect("disable");
        $("#_brnchId").multipleSelect("setSelects",
            [ '${SESSION_INFO.userBranchId}' ]);
      }
    }
  }

  /* function fn_getDateGap(sdate, edate){

   var startArr, endArr;

   startArr = sdate.split('/');
   endArr = edate.split('/');

   var keyStartDate = new Date(startArr[2] , startArr[1] , startArr[0]);
   var keyEndDate = new Date(endArr[2] , endArr[1] , endArr[0]);

   var gap = (keyEndDate.getTime() - keyStartDate.getTime())/1000/60/60/24;

   //    console.log("gap : " + gap);

   return gap;
   } */

  function girdHide() {
    //Grid Hide
    $("#_deducGridDiv").css("display", "none");
    $("#_itmDetailGridDiv").css("display", "none");
  }


  //TODO 미개발 message




  function fn_loadOrderSalesman(memId, memCode, isPop) {
    Common
        .ajax(
            "GET",
            "/sales/order/selectMemberByMemberIDCode.do",
            {
              memId : memId,
              memCode : memCode
            },
            function(memInfo) {
              if (memInfo == null) {
                Common
                    .alert('<spring:message code="sal.alert.msg.memNotFound" />'
                        + memCode + '</b>');
                $("#salesmanPopCd").val('');
                $("#hiddenSalesmanPopId").val('');

                //Clear Grid
               // fn_clearAllGrid();
              } else {
                // console.log("멤버정보 가꼬옴");
                console.log(memInfo.memId);
                if (isPop == 1) {
                  $('#hiddenSalesmanPopId')
                      .val(memInfo.memId);
                  $('#salesmanPopCd').val(memInfo.memCode);
                  $('#salesmanPopCd').removeClass("readonly");
                  $('#salesmanPopNm').val(memInfo.name);

                  Common
                      .ajax(
                          "GET",
                          "/sales/pos/getMemCode",
                          {
                            memCode : memCode
                          },
                          function(result) {

                            if (result != null) {
                              //$("#_cmbWhBrnchIdPop").val(result.brnch);
                              //$("#_payBrnchCode").val(result.brnch);
                              //getLocIdByBrnchId(result.brnch);
                            } else {
                              Common
                                  .alert('<spring:message code="sal.alert.msg.memHasNoBrnch" />');
                              $("#salesmanPopCd")
                                  .val('');
                              $(
                                  "#hiddenSalesmanPopId")
                                  .val('');
                              $('#salesmanPopNm')
                                  .val('');
                              $(
                                  "#_cmbWhBrnchIdPop")
                                  .val('');
                              $("#cmbWhIdPop")
                                  .val();
                              //Clear Grid
                              fn_clearAllGrid();
                              return;
                            }
                          });
                } else {
                  //  console.log("리스트임");
                  $('#hiddenSalesmanId').val(memInfo.memId);
                  $('#salesmanCd').val(memInfo.memCode);
                  $('#salesmanCd').removeClass("readonly");
                  $('#salesmanPopNm').val(memInfo.name);
                }
              }
            });
  }

  function createAUIGrid() {
    var posColumnLayout = [
    {
      dataField : "supRefId",
      visible : false,
      editable : false
    }, {
      dataField : "counselingNo",
      headerText : '<spring:message code="service.grid.counselingNo" />',
      width : '13%',
      editable : false
    }, {
        dataField : "supRefNo",
        headerText : '<spring:message code="supplement.text.supplementReferenceNo" />',
        width : '13%',
        editable : false
    } ,{
        dataField : "custName",
        headerText : '<spring:message code="sal.text.custName" />',
        width : '20%',
        style : 'left_style',
        editable : false
    }, {
      dataField : "tagRegisterDt",
      headerText : '<spring:message code="supplement.text.supplementTagRegisterDt" />',
      width : '15%',
      editable : false
    }, {
      dataField : "tagStatus",
      headerText : '<spring:message code="supplement.text.supplementTagStus" />',
      width : '15%',
      editable : false
    }, {
      dataField : "mainTopic",
      headerText : '<spring:message code="supplement.text.supplementMainTopicInquiry" />',
      width : '15%',
      editable : false
    },{
        dataField : "subTopic",
        headerText : '<spring:message code="supplement.text.supplementSubTopicInquiry" />',
        width : '5%',
        editable : false,
        visible : false
    }, {
        dataField : "inchgDept",
        headerText : '<spring:message code="service.text.InChrDept" />',
        width : '15%',
        editable : false
    }, {
      dataField : "subDept",
      headerText :  '<spring:message code="service.grid.subDept" />',
      width : '15%',
      editable : false
    }
    ];

    //그리드 속성 설정
    var gridPros = {
      //showRowAllCheckBox : true,
      //usePaging : true,
      //pageRowCount : 10,
      //headerHeight : 30,
      //showRowNumColumn : true,
      //showRowCheckColumn : true,

            usePaging           : true,         //페이징 사용
            pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)
            fixedColumnCount    : 1,
            showStateColumn     : true,
            displayTreeOpen     : false,
            headerHeight        : 30,
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : true
    };

    tagGridID = GridCommon.createAUIGrid("#tag_grid_wrap", posColumnLayout,
        '', gridPros); // address list
  }

  function createExcelAUIGrid() {

    var excelColumnLayout = [

    {
      dataField : "supRefId",
      visible : false,
      editable : false
    },{
      dataField : "counselingNo",
      headerText : "Counseling No",
      width : 100,
      editable : false
    }, {
      dataField : "supRefNo",
      headerText : "Supplement Reference No",
      width : 100,
      editable : false
    }, {
      dataField : "custName",
      headerText : "Customer Name",
      width : 100,
      editable : false
    }, {
      dataField : "tagRegisterDt",
      headerText : "Tag Register Date",
      width : 100,
      editable : false
    }, {
      dataField : "tagStatus",
      headerText : "Tag Status",
      width : 100,
      editable : false
    }, {
      dataField : "mainTopic",
      headerText : "Main Topic Inquiry",
      width : 100,
      editable : false
    }, {
      dataField : "subTopic",
      headerText : "Sub Topic Inquiry",
      width : 100,
      editable : false
    }, {
      dataField : "inchgDept",
      headerText : "Incharge Department",
      width : 100,
      editable : false
    }, {
      dataField : "subDept",
      headerText : "Sub Department",
      width : 100,
      editable : false
    }
    ];

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

    excelListGridID = GridCommon.createAUIGrid("excel_list_grid_wrap",
        excelColumnLayout, "", excelGridPros);
  }

  function fn_mainTopic_SelectedIndexChanged() {
	  $("#ddSubTopic option").remove();
	  doGetCombo('/supplement/getSubTopicList.do?DEFECT_GRP=' + $("#mainTopic").val(), '', '', 'ddSubTopic', 'S', '');
	  }

  function fn_inchgDept_SelectedIndexChanged() {
      $("#ddSubDept option").remove();
      doGetCombo('/supplement/getSubDeptList.do?DEFECT_GRP_DEPT=' + $("#inchgDept").val(), '', '', 'ddSubDept', 'S', '');
      }

  function fn_descCheck(ind) {
	    //(_method, _url, _jsonObj, _callback, _errcallback, _options, _header)
	    var indicator = ind;
	    var jsonObj = {
	      DEFECT_GRP : $("#mainTopic").val(),
	      DEFECT_GRP_DEPT : $("#inchgDept").val(),

	      TYPE : "SMI"
	    };

	    doGetCombo('/supplement/getSubTopicList.do?DEFECT_GRP=' + $("#mainTopic").val(), '', '', 'ddSubTopic', 'S', '');
	    doGetCombo('/supplement/getSubDeptList.do?DEFECT_GRP_DEPT=' + $("#inchgDept").val(), '', '', 'ddSubDept', 'S', '');
	  }

  function fn_asDefectEntryHideSearch(result) {
	    //DP DEFETC PART
	    $("#def_part").val(result[0].defectCode);
	    $("#def_part_id").val(result[0].defectId);
	    $("#def_part_text").val(result[0].defectDesc);
	    $("#DP").hide();
	    //DD AS PROBLEM SYMPTOM LARGE
	    $("#def_def").val(result[1].defectCode);
	    $("#def_def_id").val(result[1].defectId);
	    $("#def_def_text").val(result[1].defectDesc);
	    $("#DD").hide();
	    //DC AS PROBLEM SYMPTOM SMALL
	    $("#def_code").val(result[2].defectCode);
	    $("#def_code_id").val(result[2].defectId);
	    $("#def_code_text").val(result[2].defectDesc);
	    $("#DC").hide();
	    //DT AS SOLUTION LARGE
	    $("#def_type").val(result[3].defectCode);
	    $("#def_type_id").val(result[3].defectId);
	    $("#def_type_text").val(result[3].defectDesc);
	    $("#DT").hide();
	    //SC AS SOLUTION SMALL
	    $("#solut_code").val(result[4].defectCode);
	    $("#solut_code_id").val(result[4].defectId);
	    $("#solut_code_text").val(result[4].defectDesc);
	    $("#SC").hide();
	  }

  function fn_asDefectEntryNormal(indicator) {

	    if (indicator == 1) {
	      //DP DEFETC PART
	      $("#def_part").val("");
	      $("#def_part_id").val("");
	      $("#def_part_text").val("");
	      $("#DP").show();
	      //DD AS PROBLEM SYMPTOM LARGE
	      $("#def_def").val("");
	      $("#def_def_id").val("");
	      $("#def_def_text").val("");
	      $("#DD").show();
	      //DC AS PROBLEM SYMPTOM SMALL
	      $("#def_code").val("");
	      $("#def_code_id").val("");
	      $("#def_code_text").val("");
	      $("#DC").show();
	      //DT AS SOLUTION LARGE
	      $("#def_type").val("");
	      $("#def_type_id").val("");
	      $("#def_type_text").val("");
	      $("#DT").show();
	      //SC AS SOLUTION SMALL
	      $("#solut_code").val("");
	      $("#solut_code_id").val("");
	      $("#solut_code_text").val("");
	      $("#SC").show();
	    } else {
	    }
	  }


  function fn_getPosListAjax() {
      console.log($("#searchForm").serialize());
  //  Common.ajax("GET", "/supplement/selectSupplementList", $("#searchForm").serialize(), function(result) {
    Common.ajax("GET", "/supplement/selectTagManagementList", $("#searchForm").serialize(), function(result) {

    	console.log (result);

      AUIGrid.setGridData(tagGridID, result);
      AUIGrid.setGridData(excelListGridID, result);
    });

  }

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
</script>

<form id="rptForm">
  <input type="hidden" id="reportFileName" name="reportFileName" />
  <input type="hidden" id="viewType" name="viewType" />
  <input type="hidden" id="V_POSREFNO" name="V_POSREFNO" />
  <input type="hidden" id="V_POSMODULETYPEID" name="V_POSMODULETYPEID" />
  <input type="hidden" id="V_POSTYPEID" name="V_POSTYPEID">
  <input type="hidden" id="V_WHERESQL" name="V_WHERESQL" />
  <input type="hidden" id="V_SHOWPAYMENTDATE" name="V_SHOWPAYMENTDATE">
  <input type="hidden" id="V_SHOWKEYINBRANCH" name="V_SHOWKEYINBRANCH">
  <input type="hidden" id="V_SHOWRECEIPTNO" name="V_SHOWRECEIPTNO">
  <input type="hidden" id="V_SHOWTRNO" name="V_SHOWTRNO">
  <input type="hidden" id="V_SHOWKEYINUSER" name="V_SHOWKEYINUSER">
  <input type="hidden" id="V_SHOWPOSNO" name="V_SHOWPOSNO">
  <input type="hidden" id="V_SHOWMEMBERCODE" name="V_SHOWMEMBERCODE">
  <input type="hidden" id="V_SHOWPOSTYPEID" name="V_SHOWPOSTYPEID">
</form>
<section id="content">
  <ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Health Supplement</li>
    <li>Supplement Management</li>
  </ul>

  <aside class="title_line">
    <p class="fav">
      <a href="#" class="click_add_on">My menu</a>
    </p>
    <h2>
      <spring:message code="supplement.title.supplementTagManagement" />
    </h2>
    <ul class="right_btns">
      <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
      <li>
          <p class="btn_blue">
            <a href="#" id="_new"><spring:message code="supplement.btn.newTicket" /></a>
          </p>
        </li>
        <li>
          <p class="btn_blue">
            <a href="#" id="_update"><spring:message code="sys.btn.update" /></a>
          </p>
        </li>
      </c:if>

      <c:if test="${PAGE_AUTH.funcView == 'Y'}">
        <li>
          <p class="btn_blue">
            <a href="#" id="_search"><span class="search"></span> <spring:message code="sal.btn.search" /></a>
          </p>
        </li>
      </c:if>
    </ul>
  </aside>
  <!-- title_line end -->

  <section class="search_table">
    <form id="searchForm">
      <table class="type1">
        <caption>table</caption>
        <colgroup>
          <col style="width: 150px" />
          <col style="width: *" />
          <col style="width: 160px" />
          <col style="width: *" />
          <col style="width: 130px" />
          <col style="width: *" />
        </colgroup>
        <tbody>
          <tr>
            <th scope="row"><spring:message  code="service.grid.counselingNo" /></th>
            <td>
              <input type="text" title="" placeholder="Counseling No" class="w100p" id="_counselingNo" name="counselingNo" />
            </td>
            <th scope="row"><spring:message code="supplement.text.supplementMainTopicInquiry" /></th>
            <td>
             <!--  <select id='ddMainTopic' name='ddMainTopic' onChange="fn_SelectedIndexChanged()" class="w100p">
              </select> -->

              <select class="select w100p" id="mainTopic" name="mainTopic" onChange="fn_mainTopic_SelectedIndexChanged()">
                <option value="">Choose One</option>
                <c:forEach var="list" items="${mainTopic}" varStatus="status">
                  <option value="${list.codeId}">${list.codeName}</option>
                </c:forEach>
              </select>
            </td>
            <th scope="row"><spring:message code="supplement.text.supplementSubTopicInquiry" /></th>
            <td>
              <select id='ddSubTopic' name='ddSubTopic' class="w100p">
             </select>
            </td>
          </tr>
          <tr>
            <th scope="row"><spring:message code="supplement.text.supplementTagRegisterDt" /><span class="must">*</span></th>
            <td>
              <div class="date_set w100p">
                <p>
                  <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" name="sDate" id="_sDate" value="${bfDay}" />
                </p>
                <span><spring:message code="sal.title.to" /></span>
                <p>
                  <input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" name="eDate" id="_eDate" value="${toDay}" />
                </p>
              </div>
            </td>
            <th scope="row"><spring:message code="service.text.InChrDept" /></th>
            <td>
              <select class="select w100p" id="inchgDept" name="inchgDept" onChange="fn_inchgDept_SelectedIndexChanged()">
                <option value="">Choose One</option>
                <c:forEach var="list" items="${inchgDept}" varStatus="status">
                  <option value="${list.codeId}">${list.codeName}</option>
                </c:forEach>
              </select>
            </td>
            <th scope="row"><spring:message code="service.grid.subDept" /></th>
            <td>
              <select id='ddSubDept' name='ddSubDept' class="w100p">
             </select>
            </td>
          </tr>
          <tr>
            <th scope="row"><spring:message code="supplement.text.supplementTagStus" /></th>
            <td>
            <select class="select w100p"  id="tagStus" name="tagStus">
            <option value="">Choose One</option>
                <c:forEach var="list" items="${tagStus}" varStatus="status">
                  <option value="${list.codeId}">${list.codeName}</option>
                </c:forEach>
              </select>
            </td>
            <th></th>
            <td ></td>
            <th/></th>
            <td ></td>
          </tr>
          <tr>
          <td colspan="6"></td>
          </tr>

          <tr>
            <th scope="row"><spring:message code="supplement.text.supplementReferenceNo" /></th>
            <td>
              <input type="text" title="" placeholder="Supplement Reference No" class="w100p" id="_supRefNo" " name="supRefNo" />
            </td>
            <th scope="row"><spring:message code="sal.text.custName" /></th>
            <td>
              <input type="text" title="" placeholder="Customer Name" class="w100p" id="_custName" " name="custName" />
            </td>
            <th/></th>
            <td></td>
          </tr>

        </tbody>
      </table>

      <aside class="link_btns_wrap">
        <p class="show_btn">
          <a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a>
        </p>
        <dl class="link_list">
          <dt>
            <spring:message code="sal.title.text.link" />
          </dt>
          <dd>
            <ul class="btns">
            </ul>
            <p class="hide_btn">
              <a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a>
            </p>
          </dd>
        </dl>
      </aside>
  </section>

  <section class="search_result">
    <c:if test="${PAGE_AUTH.funcUserDefine4 == 'Y'}">
      <ul class="right_btns">
        <li><p class="btn_grid">
            <a href="#" id="excelDown"><spring:message code="sal.btn.generate" /></a>
          </p></li>
      </ul>
    </c:if>
    <aside class="title_line">
    </aside>
    <article class="grid_wrap">
      <div id="tag_grid_wrap" style="width: 100%; height: 300px; margin: 0 auto;"></div>
      <div id="excel_list_grid_wrap" style="display: none;"></div>
    </article>
  </section>
</section>
<hr />
