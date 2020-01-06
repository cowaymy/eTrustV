<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
	var gridID;
	var gridID1;
	var type1;
	var holidayDesc1;
	var holiday1;
	var state1;
	var holidaySeq1;
	var grpOrgList= new Array();
	var rData = new Array();
	var brnchType = '${branchTypeId}';
	var holidayType = ["Public Holiday", "State Holiday"];
	var workType = ["Working", "Holiday"];
	var type, branchName, holidayDesc , holiday, branchId, state, holidaySeq , applCode;

	// 그리드 세팅 - holiday_CTassign_grid_wap
    function holidayCTassignGrid() {
        var columnLayout = [
            {dataField : "holidayType",            headerText : "Holiday Type",          width : 100, editable: false},
            {dataField : "state",                      headerText : "State",                     width : 100, editable: false},
            {dataField : "holiday",                   headerText : "Date",                      width : 100, editable: false, dataType : "date"},
            {dataField : "holidayDesc",            headerText : "Description",             width : 200, editable: false},
            {dataField : "holidaySeq",              headerText : "",                            width : 0,    editable: false},
            {dataField : "dtBrnchCode",           headerText : "Branch",                   width : 100, editable: false},
            {dataField : "replacementCtPax",    headerText : "Replacement CT Pax", width : 100, editable: false},
            {dataField : "assignStatus",            headerText : "Assign Status",          width : 100, editable: false},
            {dataField : "applCode",                headerText : "Working Status",       width : 150, editable: true,
                editRenderer : {type : "ComboBoxRenderer", showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                    listFunction : function(rowIndex, columnIndex, item, dataField) {
                               var list = workType;
			                   return list;
                    },
                    keyField : "id1"
                }
            },
            {dataField : "brnchId", headerText : "",  width : 0}
        ];

        var gridPros = { usePaging : true,  pageRowCount: 20, selectionMode : "singleRow",  showRowNumColumn : true, showStateColumn : false};
        gridID1 = GridCommon.createAUIGrid("holiday_CTassign_grid_wap", columnLayout  ,"" ,gridPros);
    }


	function holidayGrid() {
	    var columnLayout = [
            {dataField : "holidayType", headerText : "Holiday Type", width : 100,
                editRenderer : {type : "ComboBoxRenderer", showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                    listFunction : function(rowIndex, columnIndex, item, dataField) {
                               var list = holidayType;
                               return list;
                    },
                    keyField : "id1"
                }
            },
            {dataField : "state", headerText : "State", width : 200,
                editRenderer : {type : "ComboBoxRenderer", showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                    listFunction : function(rowIndex, columnIndex, item, dataField) {
                               var list = rData;
                               return list;
                    },
                    keyField : "state",
                    valueField : "codeName"
                }
            },
            {dataField : "holiday", headerText : "Date",  width : 100, dataType : "date",
                editRenderer : {type : "CalendarRenderer", showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                	showExtraDays : true // 지난 달, 다음 달 여분의 날짜(days) 출력
                },
                onlyCalendar : false // 사용자 입력 불가, 즉 달력으로만 날짜입력 (기본값 : true)
            },
            {dataField : "holidayDesc",   headerText : "Description",  width : 200},
            {dataField : "holidaySeq",     headerText : "",                 width : 0}
        ];

        var gridPros = {usePaging : true,  pageRowCount: 20, editable: true, selectionMode : "singleRow",  showRowNumColumn : true, showStateColumn : false};
        gridID = GridCommon.createAUIGrid("holiday_grid_wap", columnLayout  ,"" ,gridPros);

        // 에디팅 정상 종료 이벤트 바인딩
        AUIGrid.bind(gridID, "cellEditEnd", auiCellEditingHandler);
    }

    function fn_selectState() {
        Common.ajax("GET", "/services/holiday/selectState.do",$("#holidayForm").serialize(), function(result) {
	        for (var i = 0; i < result.length; i++) {
	             var list = new Object();
	             list.codeId = result[i].codeId;
	             list.state = result[i].codeId;
	             list.codeName = result[i].codeName;
	             rData.push(list);
	         }
        });
	    return rData;
    }

	function addRow() {
	    var item = new Object();
	    item.holidayType = "";
	    item.state = "";
	    item.holiday = "";
	    item.dscription = "";
	    // parameter
	    // item : 삽입하고자 하는 아이템 Object 또는 배열(배열인 경우 다수가 삽입됨)
	    // rowPos : rowIndex 인 경우 해당 index 에 삽입, first : 최상단, last : 최하단, selectionUp : 선택된 곳 위, selectionDown : 선택된 곳 아래
	    AUIGrid.addRow(gridID, item, "first");
	}

	// 편집 핸들러
	function auiCellEditingHandler(event) {
		if(event.columnIndex == 0 && event.value == "Public Holiday"){
	        AUIGrid.setCellValue(gridID, event.rowIndex, 1, "");
	        AUIGrid.setColumnProp( gridID, 1, {editable : false});

	    } else if(event.columnIndex == 0 && event.value != "Public Holiday") {
	    	AUIGrid.setColumnProp( gridID, 1, {editable : true});
	    }
	};

    $(document).ready(function() {
		doGetCombo('/homecare/selectHomecareBranchCd.do', brnchType, '','branchId', 'M', 'fn_multiCombo');
		doGetCombo('/services/holiday/selectState.do', '' , '', 'cmbState' , 'M', 'fn_multiCombo');

		 holidayGrid();
		 holidayCTassignGrid();
		 fn_selectState();

		 $("#holiday_CTassign_grid_wap").hide();
		 $("#hiddenBtn").hide();
		 $("#hiddenBtn4").hide();

		 AUIGrid.bind(gridID, "addRow", auiAddRowHandler);
		 AUIGrid.bind(gridID, "removeRow", auiRemoveRowHandler);

		 AUIGrid.bind(gridID, "cellClick", function(event) {
	         type1= AUIGrid.getCellValue(gridID, event.rowIndex, "holidayType");
	         holidayDesc1 = AUIGrid.getCellValue(gridID, event.rowIndex, "holidayDesc");
	         holiday1 = AUIGrid.getCellValue(gridID, event.rowIndex, "holiday");
	         state1 = AUIGrid.getCellValue(gridID, event.rowIndex, "state");
	         holidaySeq1 = AUIGrid.getCellValue(gridID, event.rowIndex, "holidaySeq");
	     });

		 AUIGrid.bind(gridID1, "cellClick", function(event) {
		     type = AUIGrid.getCellValue(gridID1, event.rowIndex, "holidayType");
	         branchName = AUIGrid.getCellValue(gridID1, event.rowIndex, "dtBrnchCode");
	         holidayDesc = AUIGrid.getCellValue(gridID1, event.rowIndex, "holidayDesc");
	         holiday = AUIGrid.getCellValue(gridID1, event.rowIndex, "holiday");
	         branchId = AUIGrid.getCellValue(gridID1, event.rowIndex, "brnchId");
	         state = AUIGrid.getCellValue(gridID1, event.rowIndex, "state");
	         holidaySeq = AUIGrid.getCellValue(gridID1, event.rowIndex, "holidaySeq");
	         applCode = AUIGrid.getCellValue(gridID1, event.rowIndex, "applCode");
	    });
    });

    // 저장 - Save Button Click
    function fn_holidaySave() {
        if(fnValidationCheck()) {
            Common.ajax("POST", "/homecare/services/plan/saveHcHoliday.do", GridCommon.getEditData(gridID), function(result) {
            	Common.alert(result.message);

            	// 성공인 경우 재조회 한다.
            	if(result.code == '00') fn_holidayListSearch();
            });
    	}
    }

    function fn_multiCombo() {
        $('#branchId').change(function() {
            //console.log($(this).val());
        }).multipleSelect({
            selectAll: true, // 전체선택
            width: '100%'
        });
        $('#cmbState').change(function() {
            //console.log($(this).val());
        }).multipleSelect({
            selectAll: true, // 전체선택
            width: '100%'
        });
    }

    // 정합성 체크
    function fnValidationCheck() {
        var addList = AUIGrid.getAddedRowItems(gridID);
        var udtList = AUIGrid.getEditedRowItems(gridID);
        var delList = AUIGrid.getRemovedItems(gridID);

        // 수정건수가 없는 경우.
        if (addList.length == 0  && udtList.length == 0 && delList.length == 0) {
          Common.alert("No Change");
          return false;
        }

        // 행 추가시
        for (var i = 0; i < addList.length; i++) {
            var holidayType = addList[i].holidayType;
            var holiday = addList[i].holiday;
            var state = addList[i].state;

            if (FormUtil.isEmpty(holidayType)) {
                Common.alert("<spring:message code='sys.msg.necessary' arguments='Holiday Type' htmlEscape='false'/>");
                return false;
            }

            if (holidayType == "Public Holiday") {
                if (FormUtil.isNotEmpty(state)) {
            	    Common.alert("<spring:message text='Not allowed to place a particular state for public holiday.' htmlEscape='false'/>");
            	    return false;
            	}

            } else {
                if (FormUtil.isEmpty(state)) {
                    Common.alert("<spring:message text='Required to place a state for the holiday type.' htmlEscape='false'/>");
                    return false;
                }
            }

            if (FormUtil.isEmpty(holiday)) {
                result = false;
                // {0} is required.
                Common.alert("<spring:message code='sys.msg.necessary' arguments='Holiday' htmlEscape='false'/>");
                break;
            }
        }

        // 행 수정시
        for (var i = 0; i < udtList.length; i++) {
            var holidayType = udtList[i].holidayType;
            var holiday = udtList[i].holiday;
            var state = udtList[i].state;

            if (FormUtil.isEmpty(holidayType)) {
                Common.alert("<spring:message code='sys.msg.necessary' arguments='Holiday Type' htmlEscape='false'/>");
                return false;
            }

            if (holidayType == "Public Holiday") {
                if (FormUtil.isNotEmpty(state)) {
                    Common.alert("<spring:message text='Not allowed to place a particular state for public holiday.' htmlEscape='false'/>");
                    return false;
                }

            } else {
                if (FormUtil.isEmpty(state)) {
                    Common.alert("<spring:message text='Required to place a state for the holiday type.' htmlEscape='false'/>");
                    return false;
                }
            }

            if (FormUtil.isEmpty(holiday)) {
                Common.alert("<spring:message code='sys.msg.necessary' arguments='Holiday' htmlEscape='false'/>");
                return false;
            }
        }

        // 행삭제시
        for (var i = 0; i < delList.length; i++) {
            var holidayType = delList[i].holidayType;
            var holiday = delList[i].holiday;

            if (FormUtil.isEmpty(holidayType)) {
                Common.alert("<spring:message code='sys.msg.necessary' arguments='Holiday Type' htmlEscape='false'/>");
                return false;
            }

            if (FormUtil.isEmpty(holiday)) {
                Common.alert("<spring:message code='sys.msg.necessary' arguments='Holiday' htmlEscape='false'/>");
                return false;
            }
        }

        return true;
    }

    function auiAddRowHandler(event) {
    }

    // 조회 - Search Button Click
    function fn_holidayListSearch() {
    	if($("#hList").prop("checked")) {  // radio button - Holiday List Display
    		Common.ajax("GET", "/homecare/services/plan/selectHcHolidayList.do",$("#holidayForm").serialize(), function(result) {
                AUIGrid.setGridData(gridID, result);
            });
    	} else { // radio button - Replacement DT Assign Status
    		$("#type1").val(type1.substr(0,1));
            $("#holidayDesc1").val(holidayDesc1);
            $("#holiday1").val( holiday1);
            $("#holidaySeq1").val(holidaySeq1);
            $("#state1").val(state1);

    		Common.ajax("GET", "/homecare/services/plan/selectDTAssignList.do", $("#holidayForm").serialize(), function(result2) {
                AUIGrid.setGridData(gridID1, result2);
            });
    	}
    }

    function fn_radioBtn(val) {
        if(val == 1) {
            $("#holiday_grid_wap").show();
            $("#holiday_CTassign_grid_wap").hide();
            $("#hiddenBtn").hide();
            $("#hiddenBtn4").hide();
            $("#hiddenBtn1").show();
            $("#hiddenBtn2").show();
            $("#hiddenBtn3").show();

            AUIGrid.resize(gridID);

        } else {
        	if(FormUtil.isEmpty(type1)) {
        		Common.alert("No Select Row", $("#hList").prop("checked",true));
        		return;
        	}
        	fn_holidayListSearch();

            $("#holiday_CTassign_grid_wap").show();
            $("#holiday_grid_wap").hide();
            $("#hiddenBtn").show();
            $("#hiddenBtn1").hide();
            $("#hiddenBtn2").hide();
            $("#hiddenBtn3").hide();
            $("#hiddenBtn4").show();

            AUIGrid.resize(gridID1);
        }
    }

    function fn_DTEntry() {
        if(applCode == "Working") {
    		Common.alert("Working day");
    		return;
    	}
    	if(FormUtil.isEmpty(type)) {
            Common.alert("Retry to click a column");
            return;
        }
    	Common.popupDiv("/homecare/services/plan/replacementDTEntryPop.do?holidayType=" + type +"&branchName=" +  branchName +  "&holidayDesc=" + holidayDesc + "&holiday=" + holiday + "&branchId=" + branchId + "&state=" + state + "&holidaySeq=" + holidaySeq ,null, null , true , '_NewAddDiv1');
    }

    function fn_ChangeApplType() {
    	var objJson = GridCommon.getEditData(gridID1);

    	$("#type1").val(type1.substr(0,1));
        $("#holidayDesc1").val(holidayDesc1);
        $("#holiday1").val( holiday1);
        $("#holidaySeq1").val(holidaySeq1);
        $("#state1").val(state1);

        if(type == undefined) {
        	Common.alert("Retry to click a column");
        	return;
        }

    	Common.ajax("GET", "/services/holiday/changeApplType.do?holidayType=" + type +"&branchName=" +  branchName +  "&holidayDesc=" + holidayDesc + "&holiday=" + holiday + "&branchId=" + branchId + "&state=" + state + "&holidaySeq=" + holidaySeq+"&applCode=" + applCode, objJson ,  function(result) {
    		  fn_holidayListSearch();
    		  fn_radioBtn(1);
    		  $("#hList").prop("checked",true);
    	 });
    }

    function removeRow() {
    	AUIGrid.removeRow(gridID, "selectedIndex");
        AUIGrid.removeSoftRows(gridID);
    }

    function auiRemoveRowHandler(){}

</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Organization</li>
    <li>Holiday List Search</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Holiday List Search</h2>
<ul class="right_btns">
<c:if test="${PAGE_AUTH.funcView == 'Y'}">
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_holidayListSearch()"><span class="search"></span>Search</a></p></li>
    </c:if>
<!--     <li><p class="btn_blue"><a href="#" onclick="javascript:fn_Clear()"><span class="clear"></span>Clear</a></p></li> -->
</ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
	<form action="#" method="post" id="holidayForm" autocomplete=off>
		<input type ="hidden" id="type1" name="type1">
		<input type ="hidden" id="holidayDesc1" name="holidayDesc1">
		<input type ="hidden" id="holiday1" name="holiday1">
		<input type ="hidden" id="holidaySeq1" name="holidaySeq1">
		<input type ="hidden" id="state1" name="state1">
		<!-- table start -->
		<table class="type1">
			<caption>table</caption>
			<colgroup>
			    <col style="width:180px" />
			    <col style="width:*" />
			    <col style="width:180px" />
			    <col style="width:*" />
			    <col style="width:180px" />
			    <col style="width:*" />
			</colgroup>
			<tbody>
				<tr>
				    <th scope="row">Holiday Type</th>
				    <td>
				        <select class="w100p" id="type" name="type">
				            <option value="">All</option>
				            <option value="P">Public</option>
				            <option value="S">State</option>
				        </select>
				    </td>
				    <th scope="row">State</th>
				    <td>
				        <select class="multy_select w100p" multiple="multiple" id="cmbState" name="cmbState">
				        </select>
				    </td>
				    <th scope="row">Holiday</th>
				    <td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_dateHc w100p" id="holidayDt" name="holidayDt"/></td>
				</tr>
				<tr>
				    <th scope="row">Assign Status</th>
				    <td>
				        <select class="multy_select w100p" multiple="multiple" id="assignState" name="assignState">
				            <option value="Active">Active</option>
				            <option value="Complete">Complete</option>
				        </select>
				    </td>
				    <th scope="row" id="">Branch</th>
				    <td>
				        <div class="search_100p">
				        <select class="multy_select w100p" multiple="multiple" id="branchId" name="branchId">
				        </select>
				        </div>
				    </td>
				    <th></th>
				    <td></td>
				</tr>
			</tbody>
		</table>
		<!-- table end -->
	</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <td>
    <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
    <label><input id="hList" type="radio" name="rdoBtn" checked="checked" onclick="fn_radioBtn(1)"/><span>Holiday List Display</span></label>
    </c:if>
    <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
    <label><input type="radio" name="rdoBtn" onclick="fn_radioBtn(2)" /><span>Replacement DT Assign Status</span></label>
    </c:if>
    </td>
</tr>
</tbody>
</table>

<ul class="right_btns">
    <li><p class="btn_grid" id="hiddenBtn1"><a href="#" onclick="javascript:addRow()">ADD</a></p></li>
    <li><p class="btn_grid" id="hiddenBtn2"><a href="#" onclick="javascript:removeRow()">DEL</a></p></li>
    <li><p class="btn_grid" id="hiddenBtn3"><a href="#" onclick="javascript:fn_holidaySave()">SAVE</a></p></li>
    <li><p class="btn_grid" id="hiddenBtn4"><a href="#" onclick="javascript:fn_ChangeApplType()">Change Work Status</a></p></li>
    <li><p class="btn_grid" id="hiddenBtn"><a href="#" onclick="javascript:fn_DTEntry()">Replacement DT Entry</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="holiday_grid_wap" style="width:100%; height:300px; margin:0 auto;"></div>
<div id="holiday_CTassign_grid_wap" style="width:100%; height:300px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->
