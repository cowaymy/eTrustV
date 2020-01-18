<!--=================================================================================================
* Task  : Logistics
* File Name : serialScanningGISMOList.jsp
* Description : GI Serial No. Scanning (SMO)
* Author : KR-OHK
* Date : 2019-11-21
* Change History :
* ------------------------------------------------------------------------------------------------
* [No]  [Date]        [Modifier]     [Contents]
* ------------------------------------------------------------------------------------------------
*  1     2019-11-21  KR-OHK        Init
*=================================================================================================-->
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<script type="text/javaScript" language="javascript">
    var mainGridID;

    var codeList = [];
    <c:forEach var="list" items="${codeList306}">
    codeList.push({
        codeId : "${list.codeId}",
        codeMasterId : "${list.codeMasterId}",
        code : "${list.code}",
        codeName : "${list.codeName}",
        codeDesc : "${list.codeDesc}"
    });
    </c:forEach>

    <c:forEach var="list" items="${codeList308}">
    codeList.push({
        codeId : "${list.codeId}",
        codeMasterId : "${list.codeMasterId}",
        code : "${list.code}",
        codeName : "${list.codeName}",
        codeDesc : "${list.codeDesc}"
    });
    </c:forEach>

    $(document).ready(function() {
    	$("#wrap").css({"min-width":"100%"});
        $("#container").css({"min-width":"100%"});

    	createAUIGrid();

    	doGetComboData('/common/selectCodeList.do', { groupCode : 339 , orderValue : 'CODE'}, '${defLocType}', 'locType', 'M','f_multiCombo');
    	doGetComboData('/common/selectCodeList.do', { groupCode : 339 , orderValue : 'CODE'}, '', 'locTypeTo', 'M','f_multiCombo');

    	doGetCombo('/common/selectCodeList.do', '11', '', 'cmbCategory', 'M', 'f_multiCombo');
        doGetCombo('/common/selectCodeList.do', '15', '', 'cmbType', 'M','f_multiCombo');

        if(Common.checkPlatformType() == "mobile") {
    		 $(".path").css("display", "none");
    		 $("#ulButtonArea").css("display", "none");
    	     $("#btnMobileClose").attr("style", "");
    	 }

    	 $("#btnClose").click(function() {
             window.close();
         });

    	$("#btnSearch").click(function() {
        	SearchListAjax();
        });

        //excel Download
        $('#excelDown').click(function() {
           GridCommon.exportTo("grid_sum_list", "xlsx", "GI Serial No Scanning SMO");
        });

        $('#delivery').click(function() {
            var checkedItems = AUIGrid.getCheckedRowItemsAll(mainGridID);

            if (checkedItems.length <= 0) {
                Common.alert('No data selected.');
                return false;
            } else {
                var checkedItems = AUIGrid.getCheckedRowItems(mainGridID);
                var checkCnt = 0;

                var fromlocid = checkedItems[0].item.fromlocid;
                var tolocid = checkedItems[0].item.tolocid;

                for (var i = 0, len = checkedItems.length; i < len; i++) {
                    checkCnt++ ;

                    if(checkedItems[i].item.tolocid != tolocid) {
                        Common.alert("To Location is different.");
                        return false;
                    }
                    if(checkedItems[i].item.fromlocid != fromlocid) {
                        Common.alert("From Location is different.");
                        return false;
                    }

                    if(checkCnt > 100) {
                        Common.alert("You can select up to 100 items.");
                        return false;
                    }
                }

                fn_smoIssuePop();
            }
        });

        AUIGrid.bind(mainGridID, "rowCheckClick", function(event){

            var checked = AUIGrid.getCheckedRowItems(mainGridID);
            var reqno = AUIGrid.getCellValue(mainGridID, event.rowIndex, "reqstno");
            var checkCnt = 0;

            for (var i = 0; i < checked.length; i++) {
            	checkCnt++ ;

            	if(event.checked) {
	            	if(checked[i].item.tolocid != event.item.tolocid) {
	                    Common.alert("To Location is different.");
	                    var rown = AUIGrid.getRowIndexesByValue(mainGridID, "reqstno" , reqno);

	                    for (var i = 0; i < rown.length; i++)
	                    {
	                        AUIGrid.addUncheckedRowsByIds(mainGridID, AUIGrid.getCellValue(mainGridID, rown[i], "rnum"));
	                    }
	                    return false;
	                }
	                if(checked[i].item.fromlocid != event.item.fromlocid) {
	                    Common.alert("From Location is different.");
	                    var rown = AUIGrid.getRowIndexesByValue(mainGridID, "reqstno" , reqno);

	                    for (var i = 0; i < rown.length; i++)
	                    {
	                        AUIGrid.addUncheckedRowsByIds(mainGridID, AUIGrid.getCellValue(mainGridID, rown[i], "rnum"));
	                    }
	                    return false;
	                }

	                if(checkCnt > 100) {
	                    Common.alert("You can select up to 100 items.");
	                    var rown = AUIGrid.getRowIndexesByValue(mainGridID, "reqstno" , reqno);

	                    for (var i = 0; i < rown.length; i++)
	                    {
	                        AUIGrid.addUncheckedRowsByIds(mainGridID, AUIGrid.getCellValue(mainGridID, rown[i], "rnum"));
	                    }
	                    return false;
	                }
                }
            }
        });
    });

    function createAUIGrid() {
    	var mainColumnLayout = [
            {dataField: "rnum",headerText :"<spring:message code='log.head.rownum'/>",width:120    ,height:30 , visible:false},
            {dataField:"reqstno", headerText:"Request No", width:120, height:30,
            	renderer:{type:"LinkRenderer", baseUrl:"javascript", jsCallback : function(rowIndex, columnIndex, value, item) {
                    getDeliveryPop(item);
                }}
            },
            {dataField:"reqstdt", headerText:"Dlvd. Req. Date", width:120, editable:false, dataType:"date", dateInputFormat:"dd/mm/yyyy", formatString:"dd/mm/yyyy"},
            {dataField:"toloc", headerText:"To Location", width:250, height:30, style:"aui-grid-user-custom-left"},
            {dataField:"frmlocid", headerText:"From Loc ID", width:100, height:30, visible:false},
            {dataField:"tolocid", headerText:"To Loc ID", width:100, height:30, visible:false},
            {dataField: "bndlNo",headerText :"Bundle No"        ,width:120    ,height:30                },
            {dataField: "ordno",headerText :"Order No."        ,width:100    ,height:30                },
            {
                dataField : "refDocNo",
                headerText : "<spring:message code='log.head.refdocno'/>",
                width : 120,
                height : 30
              },
              {
                  dataField : "itmCode",
                  headerText : "<spring:message code='log.head.matcode'/>",
                  width : 100,
                  height : 30,
                  visible : true
                },
                {
                  dataField : "itmName",
                  headerText : "Mat. Name",
                  width : 300,
                  height : 30,
                  style:"aui-grid-user-custom-left"
                },
            {dataField:"reqstqty", headerText:"Req. Qty", width:120, height:30, style:"aui-grid-user-custom-right"},
            {dataField:"delqty", headerText:"Delivered Qty", width:120, height:30, style:"aui-grid-user-custom-right"},
            {dataField:"remainqty", headerText:"Remain Qty", width:120, height:30, style:"aui-grid-user-custom-right"},
            {dataField:"appntDt", headerText:"Appointment Date", width:140, editable:false, dataType:"date", dateInputFormat:"dd/mm/yyyy", formatString:"dd/mm/yyyy"},
            {dataField:"trnsctypedtl", headerText:"Movement Type", width:250, height:30, labelFunction:function(rowIndex, columnIndex, value, headerText, item) {
                return getCodeList("CODE", "", "308", item.trnsctypedtl);
            }}
        ];

    	var mainGridOptions = {
    		rowIdField : "rnum",
    	    // 페이지 설정
    	    usePaging : false,
    	    // 한 화면에 출력되는 행 개수 10
    	    pageRowCount : 10,
    	    showFooter : false,
    	    fixedColumnCount : 1,
    	    // 편집 가능 여부 (기본값 : false)
    	    editable : false,
    	    // 엔터키가 다음 행이 아닌 다음 칼럼으로 이동할지 여부 (기본값 : false)
    	    enterKeyColumnBase : true,
    	    // 셀 선택모드 (기본값: singleCell)
    	    selectionMode : "multipleCells",
    	    // 컨텍스트 메뉴 사용 여부 (기본값 : false)
    	    useContextMenu : true,
    	    // 필터 사용 여부 (기본값 : false)
    	    enableFilter : true,
    	    // 그룹핑 패널 사용
    	    useGroupingPanel : false,
    	    // 상태 칼럼 사용
    	    showStateColumn : false,
    	    // 그룹핑 또는 트리로 만들었을 때 펼쳐지게 할지 여부 (기본값 : false)
    	    displayTreeOpen : true,
    	    noDataMessage : "<spring:message code='sys.info.grid.noDataMessage' />",
    	    groupingMessage : "<spring:message code='sys.info.grid.groupingMessage' />",
    	    //selectionMode : "multipleCells",
    	    //rowIdField : "stkid",
    	    enableSorting : true,
    	    showRowCheckColumn : true
    	};

    	mainGridID = GridCommon.createAUIGrid("grid_sum_list", mainColumnLayout, "", mainGridOptions);
    }

    function SearchListAjax() {
    	if(FormUtil.isEmpty($("#searchDeliverySDate").val()) || FormUtil.isEmpty($("#searchDeliveryEDate").val())){
            Common.alert('Please enter Dlvd. Req. Date.');
            return false;
        }

        var locTypeVal = $("#locType option:selected").val();

        if(FormUtil.isEmpty(locTypeVal)) {
           Common.alert('Please enter From Location.');
           return false;
        }

    	var locCodeVal = $("#locCode option:selected").val();

        if(FormUtil.isEmpty(locCodeVal)) {
           Common.alert('Please enter From Location.');
           return false;
        }

        Common.ajax("POST", "/logistics/SerialMgmt/selectSerialScanningGISMOList.do", $("#searchForm").serializeJSON(), function (result) {
            AUIGrid.setGridData(mainGridID, result);
        });
    }

    function getCodeList(codeType, codeId, codeMasterId, code) {
        var searchData = codeList.filter(function(e) {
            if (codeType == "ID") {
                return e.code == code;
            }
            else if (codeType == "CODE") {
                return e.codeMasterId == codeMasterId && e.code == code;
            }
            else {
                return e.code == code;
            }
        });

        if (searchData.length > 0) {
            return searchData[0].codeName;
        }
        else {
            return "";
        }
    }

    function fn_smoIssuePop(){
        var checkedItems = AUIGrid.getCheckedRowItems(mainGridID);
        var str = "";
        var reqstNoList = "";

        for (var i = 0, len = checkedItems.length; i < len; i++) {
          //rowItem = checkedItems[i];
          console.log(checkedItems[i].item.reqstno);
          if(i == len-1) {
        	  reqstNoList += checkedItems[i].item.reqstno;
          } else {
        	  reqstNoList += checkedItems[i].item.reqstno +",";
          }
        }
        //console.log(reqstNoList);
        $("#zReqstno").val(reqstNoList);
        $("#zRcvloc").val(checkedItems[0].item.frmlocid); // From Location
        $("#zReqloc").val(checkedItems[0].item.tolocid); // To Location

        if(Common.checkPlatformType() == "mobile") {
          popupObj = Common.popupWin("frmNew", "/logistics/stockMovement/smoIssueOutPop.do", {width : "1000px", height : "720", resizable: "no", scrollbars: "yes"});
        } else{
          Common.popupDiv("/logistics/stockMovement/smoIssueOutPop.do", null, null, true, '_divSmoIssuePop');
        }
      }

    function getDeliveryPop(item) {
        $("#zReqstno").val(item.reqstno);
        $("#zReqloc").val(item.tolocid);
        $("#zRcvloc").val(item.frmlocid);

        if(Common.checkPlatformType() == "mobile") {
            popupObj = Common.popupWin("frmNew", "/logistics/stockMovement/smoIssueOutPop.do", {width : "1000px", height : "720", resizable: "no", scrollbars: "yes"});
        } else{
            Common.popupDiv("/logistics/stockMovement/smoIssueOutPop.do", null, null, true, '_divSmoIssuePop');
        }
    }

    function fn_PopSmoIssueClose(){
        if(popupObj!=null) popupObj.close();
        SearchListAjax();
    }

    function f_multiCombo() {
        $(function() {

        	$('#locType').change(function() {
                if ($('#locType').val() != null && $('#locType').val() != "" ){
                    var searchlocgb = $('#locType').val();

                    var locgbparam = "";
                    for (var i = 0 ; i < searchlocgb.length ; i++){
                        if (locgbparam == ""){
                            locgbparam = searchlocgb[i];
                         }else{
                            locgbparam = locgbparam +"∈"+searchlocgb[i];
                         }
                     }

                     var param = {searchlocgb:locgbparam , grade:""}
                     CommonCombo.make('locCode', '/common/selectStockLocationList2.do', param , '${defLocCode}', {type: 'M', id:'codeId', name:'codeName', width:'50%', isCheckAll:false});
                  }
            }).multipleSelect({
                selectAll : true
            });

        	$('#locTypeTo').change(function() {
        		if ($('#locTypeTo').val() != null && $('#locTypeTo').val() != "" ){
        			var searchlocgb = $('#locTypeTo').val();

                    var locgbparam = "";
                    for (var i = 0 ; i < searchlocgb.length ; i++){
                        if (locgbparam == ""){
                            locgbparam = searchlocgb[i];
                         }else{
                            locgbparam = locgbparam +"∈"+searchlocgb[i];
                         }
                     }

                     var param = {searchlocgb:locgbparam , grade:""}
                     CommonCombo.make('locCodeTo', '/common/selectStockLocationList2.do', param , '', {type: 'M', id:'codeId', name:'codeName', width:'50%', isCheckAll:false});
                  }
            }).multipleSelect({
                selectAll : true
            });

        	$('#cmbCategory').change(function() {

            }).multipleSelect({
                selectAll : true, // 전체선택
                width : '46%'
            });

            $('#cmbType').change(function() {

            }).multipleSelect({
                selectAll : true,
                width : '46%'
            });
        });
    }

</script>

<section id="content"><!-- content start -->
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
        <li>Logistics</li>
        <li>S/N Management</li>
        <li>SMO GI S/N Scanning</li>
    </ul>

    <aside class="title_line"><!-- title_line start -->
        <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
        <h2>SMO GI S/N Scan</h2>

        <ul class="right_btns">
            <li><p class="btn_blue"><a id="btnSearch"><span class="search" ></span>Search</a></p></li>
            <li  id="btnMobileClose" style="display:none"><p class="btn_blue"><a id="btnClose" style="min-width:10px!important;width:10px!important"><span class="clear"></span></a></p></li>
        </ul>
    </aside><!-- title_line end -->

    <section class="search_table"><!-- search_table start -->
        <form id="searchForm" name="searchForm">
            <table class="type1"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:26%" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Dlvd. Req. Date<span class="must">*</span></th>
                        <td>
                            <div class="date_set w100p">
                                <!-- date_set start -->
                                <p>
                                    <input id="searchDeliverySDate" name="searchDeliverySDate" type="text" title="Delivery Start Date" placeholder="DD/MM/YYYY" class="j_date" value="${GR_FROM_DT}" readonly />
                                </p>
                                <span> To </span>
                                <p>
                                    <input id="searchDeliveryEDate" name="searchDeliveryEDate" type="text" title="Delivery End Date" placeholder="DD/MM/YYYY" class="j_date" value="${GR_TO_DT}" readonly />
                                </p>
                            </div>
                        </td>
                    </tr>

                    <tr>
                        <th scope="row">From Location<span class="must">*</span></th>
                        <td>
                            <select id="locType" name="locType[]" multiple="multiple" style="width:100px"></select>
                            <select id="locCode" name="locCode[]" multiple="multiple" style="width:350px"><option value="">Choose One</option></select>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">To Location</th>
                        <td>
                            <select id="locTypeTo" name="locTypeTo[]" multiple="multiple" style="width:100px"></select>
                            <select id="locCodeTo" name="locCodeTo[]" style="width:110px"></select>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Appointment Date</th>
                        <td>
                            <div class="date_set w100p">
                                <!-- date_set start -->
                                <p>
                                    <input id="searchSAppntDt" name="searchSAppntDt" type="text" title="Appointment Start Date" placeholder="DD/MM/YYYY" class="j_date" value="" readonly />
                                </p>
                                <span> To </span>
                                <p>
                                    <input id="searchEAppntDt" name="searchEAppntDt" type="text" title="Appointment End Date" placeholder="DD/MM/YYYY" class="j_date" value="" readonly />
                                </p>
                            </div>
                        </td>
                    </tr>
                    <tr style="display:none">
                        <th scope="row">Req. No/To Loc.</th>
                        <td>
                            <input type="text"  id="searchRequestNo" name="searchRequestNo"  class="w100p" />
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Category /Type</th>
                        <td>
                            <select id="cmbCategory" name="cmbCategory[]" multiple="multiple" style="width:100px"></select>
                            <select id="cmbType" name="cmbType[]" multiple="multiple" style="width:100px"></select>
                        </td>
                   </tr>
                   <tr>
                        <th scope="row">Item Code/Name</th>
                        <td>
                            <input type="text"  id="searchItm" name="searchItm"  class="w100p" />
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Bundle/Ord. /Ref.</th>
                        <td>
                            <input type="text"  id="searchRequestNo2" name="searchRequestNo2"  class="w100p" />
                        </td>
                    </tr>
                </tbody>
            </table><!-- table end -->
        </form>
	</section><!-- search_table end -->

     <section class="search_result"><!-- search_result start -->
        <ul class="right_btns">
            <li><p class="btn_grid"><a id="delivery">DELIVERY</a></p></li>
            <li id="ulButtonArea"><p class="btn_grid"><a href="#" id="excelDown"><spring:message code='sys.btn.excel.dw'/></a></p></li>
        </ul>

        <article class="grid_wrap"><!-- grid_wrap start -->
            <div id="grid_sum_list" class="autoGridHeight"></div>
        </article><!-- grid_wrap end -->

    </section><!-- search_result end -->

    <form id="frmNew" name="frmNew" action="#" method="post">
        <input type="hidden" name="zReqstno" id="zReqstno" />
        <input type="hidden" name="zReqloc" id="zReqloc" />
        <input type="hidden" name="zRcvloc" id="zRcvloc" />
    </form>

</section><!-- content end -->