<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style type="text/css">
.calTitle {
	display : table;
	margin-left : auto;
	margin-right : auto;
	margin-top : 20px;
	margin-bottom : 20px;
	text-indent : 0;
	text-align : center;
}

</style>

<script type="text/javaScript">
	var calGridID1;
	var calGridID2;
	var calGridID3;
	var calGridID4;
	var calGridID5;
	var calGridID6;
	var calGridID7;
	var calGridID8;
	var calGridID9;
	var calGridID10;
	var calGridID11;
	var calGridID12;
	var chkArray = ['chkSun', 'chkMon', 'chkTue', 'chkWed', 'chkThu', 'chkFri', 'chkSat'];
	var isChkEnable = false;
	// 현재 년도
	var date = new Date;
    var curYear = date.getFullYear();

	// 월달력 그리드
	function CTMonthCalGrid() {
	    //AUIGrid 칼럼 설정
	    var columnLayout = [
	        {dataField : "month", headerText : "MONTH", children : [
	            {dataField : "chkSun",   headerText : "SUN",     colSpan : 2,    renderer : {
	                type : "CheckBoxEditRenderer",
	                showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
	                editable : false, // 체크박스 편집 활성화 여부(기본값 : false)
	                // 체크박스 visible 함수
	                visibleFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField) {
	                    if (FormUtil.isEmpty(item.sun)) {
	                        return false; // false 반환하면 visible : false
	                    } else {
	                        return true;
	                    }
	                }
	            },  width : 23},
	            {dataField : "sun",    colSpan : -1,   editable : false,  width : 31},
	            {dataField : "chkMon",   headerText : "MON",     colSpan : 2,    renderer : {
	                type : "CheckBoxEditRenderer",
	                showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
	                editable : false, // 체크박스 편집 활성화 여부(기본값 : false)
	                // 체크박스 visible 함수
	                visibleFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField) {
	                    if (FormUtil.isEmpty(item.mon)) {
	                        return false; // false 반환하면 visible : false
	                    } else {
	                        return true;
	                    }
	                }
	            },  width : 23},
	            {dataField : "mon",    colSpan : -1,   editable : false,  width : 31},
	            {dataField : "chkTue",   headerText : "TUE",     colSpan : 2,    renderer : {
	                type : "CheckBoxEditRenderer",
	                showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
	                editable : false, // 체크박스 편집 활성화 여부(기본값 : false)
	                // 체크박스 visible 함수
	                visibleFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField) {
	                    if (FormUtil.isEmpty(item.tue)) {
	                        return false; // false 반환하면 visible : false
	                    } else {
	                        return true;
	                    }
	                }
	            },  width : 23},
	            {dataField : "tue",     colSpan : -1,   editable : false,  width : 31},
	            {dataField : "chkWed",   headerText : "WED",     colSpan : 2,    renderer : {
	                type : "CheckBoxEditRenderer",
	                showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
	                editable : false, // 체크박스 편집 활성화 여부(기본값 : false)
	                // 체크박스 visible 함수
	                visibleFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField) {
	                    if (FormUtil.isEmpty(item.wed)) {
	                        return false; // false 반환하면 visible : false
	                    } else {
	                        return true;
	                    }
	                }
	            },  width : 23},
	            {dataField : "wed",   colSpan : -1,   editable : false,  width : 31},
	            {dataField : "chkThu",   headerText : "THU",     colSpan : 2,    renderer : {
	                type : "CheckBoxEditRenderer",
	                showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
	                editable : false, // 체크박스 편집 활성화 여부(기본값 : false)
	                // 체크박스 visible 함수
	                visibleFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField) {
	                    if (FormUtil.isEmpty(item.thu)) {
	                        return false; // false 반환하면 visible : false
	                    } else {
	                        return true;
	                    }
	                }
	            },  width : 23},
	            {dataField : "thu",     colSpan : -1,   editable : false,  width : 31},
	            {dataField : "chkFri",   headerText : "FRI",     colSpan : 2,    renderer : {
	                type : "CheckBoxEditRenderer",
	                showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
	                editable : false, // 체크박스 편집 활성화 여부(기본값 : false)
	                // 체크박스 visible 함수
	                visibleFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField) {
	                    if (FormUtil.isEmpty(item.fri)) {
	                        return false; // false 반환하면 visible : false
	                    } else {
	                        return true;
	                    }
	                }
	            },  width : 23},
	            {dataField : "fri",      colSpan : -1,   editable : false,   width : 31},
	            {dataField : "chkSat",   headerText : "SAT",     colSpan : 2,    renderer : {
	                type : "CheckBoxEditRenderer",
	                showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
	                editable : false, // 체크박스 편집 활성화 여부(기본값 : false)
	                // 체크박스 visible 함수
	                visibleFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField) {
	                    if (FormUtil.isEmpty(item.sat)) {
	                        return false; // false 반환하면 visible : false
	                    } else {
	                        return true;
	                    }
	                }
	            },  width : 23},
	            {dataField : "sat",     colSpan : -1,   editable : false,   width : 31}
	        ]}
	    ];

	     // 그리드 속성 설정
	    var gridPros = {
	    	 //usePaging           : true,         //페이징 사용
             pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)
             fixedColumnCount    : 0,        // 틀고정(index)
             enableSorting          : false,      // 헤더 정렬
             //editable            : true,
             //selectionMode : "multipleCells", // 셀 선택모드 (기본값: singleCell): (singleCell, singleRow), (multipleCells, multipleRows)
             showStateColumn     : false,
             displayTreeOpen     : false,
             headerHeight        : 30,
             useGroupingPanel    : false,        //그룹핑 패널 사용
             skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
             wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
             showRowNumColumn  : false,        //줄번호 칼럼 렌더러 출력
             showEditedCellMarker : false,      // 수정마커 표시안함.
	    };

	    calGridID1 = AUIGrid.create("#grid_ctMonCal01", columnLayout, gridPros);
	    calGridID2 = AUIGrid.create("#grid_ctMonCal02", columnLayout, gridPros);
	    calGridID3 = AUIGrid.create("#grid_ctMonCal03", columnLayout, gridPros);
	    calGridID4 = AUIGrid.create("#grid_ctMonCal04", columnLayout, gridPros);
	    calGridID5 = AUIGrid.create("#grid_ctMonCal05", columnLayout, gridPros);
	    calGridID6 = AUIGrid.create("#grid_ctMonCal06", columnLayout, gridPros);
	    calGridID7 = AUIGrid.create("#grid_ctMonCal07", columnLayout, gridPros);
	    calGridID8 = AUIGrid.create("#grid_ctMonCal08", columnLayout, gridPros);
	    calGridID9 = AUIGrid.create("#grid_ctMonCal09", columnLayout, gridPros);
	    calGridID10 = AUIGrid.create("#grid_ctMonCal10", columnLayout, gridPros);
	    calGridID11 = AUIGrid.create("#grid_ctMonCal11", columnLayout, gridPros);
	    calGridID12 = AUIGrid.create("#grid_ctMonCal12", columnLayout, gridPros);

	}

    $(document).ready(function(){
    	//grid 생성
        CTMonthCalGrid();
        $("#calYear").text(curYear);

        // 달력을 조회한다.
        fn_selectYearCalendar($("#calYear").text());

        /* for(var i=1; i<=12; ++i) {
        	AUIGrid.bind(eval('calGridID'+i), "cellClick", function( event ) {
       			if (event.dataField.indexOf("chk") != -1) {
       				// isChkEndable = true인 경우만 체크되도록 한다.
       				if(isChkEnable) {
       					AUIGrid.setCellValue(event.pid, event.rowIndex, event.columnIndex, event.value);
       				} else {
       					// 체크박스 체크안되게 처리.
       					if(event.value) {
       						AUIGrid.setCellValue(event.pid, event.rowIndex, event.columnIndex, false);
       					} else {
       						AUIGrid.setCellValue(event.pid, event.rowIndex, event.columnIndex, true);
       					}
       				}
       			}
            });
        } */
    });

    function fn_selectYearCalendar(calYear) {
    	Common.ajax("GET", "/services/serviceGroup/selectYearCalendar.do?paramYear="+calYear, '', function(result) {
            AUIGrid.setColumnPropByDataField(calGridID1, "month", {headerText : "JAN"});
            AUIGrid.setColumnPropByDataField(calGridID2, "month", {headerText : "FEB"});
            AUIGrid.setColumnPropByDataField(calGridID3, "month", {headerText : "MAR"});
            AUIGrid.setColumnPropByDataField(calGridID4, "month", {headerText : "APR"});
            AUIGrid.setColumnPropByDataField(calGridID5, "month", {headerText : "MAY"});
            AUIGrid.setColumnPropByDataField(calGridID6, "month", {headerText : "JUN"});
            AUIGrid.setColumnPropByDataField(calGridID7, "month", {headerText : "JUL"});
            AUIGrid.setColumnPropByDataField(calGridID8, "month", {headerText : "AUG"});
            AUIGrid.setColumnPropByDataField(calGridID9, "month", {headerText : "SEP"});
            AUIGrid.setColumnPropByDataField(calGridID10, "month", {headerText : "OCT"});
            AUIGrid.setColumnPropByDataField(calGridID11, "month", {headerText : "NOV"});
            AUIGrid.setColumnPropByDataField(calGridID12, "month", {headerText : "DEC"});

            AUIGrid.setGridData(calGridID1, result.MON_01);
            AUIGrid.setGridData(calGridID2, result.MON_02);
            AUIGrid.setGridData(calGridID3, result.MON_03);
            AUIGrid.setGridData(calGridID4, result.MON_04);
            AUIGrid.setGridData(calGridID5, result.MON_05);
            AUIGrid.setGridData(calGridID6, result.MON_06);
            AUIGrid.setGridData(calGridID7, result.MON_07);
            AUIGrid.setGridData(calGridID8, result.MON_08);
            AUIGrid.setGridData(calGridID9, result.MON_09);
            AUIGrid.setGridData(calGridID10, result.MON_10);
            AUIGrid.setGridData(calGridID11, result.MON_11);
            AUIGrid.setGridData(calGridID12, result.MON_12);

            // Select Service DayList
            Common.ajax("GET", "/services/serviceGroup/selectSubGroupServiceDayList.do?paramYear="+ calYear +"&paramAreaId=${params.areaID}"+"&paramSubGrpType=${params.subGrpType}", '', function(result) {
                for(var i=0; i<result.length; ++i) {
                    var rowIdx = AUIGrid.getRowIndexesByValue(eval('calGridID'+result[i].noscvMm), chkArray[result[i].noscvDay-1], result[i].noscvDt);
                    // 해당내역 체크
                    AUIGrid.setCellValue(eval('calGridID'+result[i].noscvMm), rowIdx, chkArray[result[i].noscvDay-1], true);
                }
            });
        });
    }

    // Edit 버튼 클릭시
    function fn_editCalendar() {
    	if(isChkEnable) return;

    	Common.alert("Can be modified.");
    	fn_setChkEditble(true);
    }

    // 체크박스 editable 설정
    function fn_setChkEditble(isChk) {
    	var colIdx;
    	isChkEnable = isChk;

        for(var i=1; i<=12; ++i) {
            var gridObj = eval('calGridID'+i);

            for(var z=0; z<chkArray.length; ++z) {
                colIdx = AUIGrid.getColumnIndexByDataField(gridObj, chkArray[z]);
                AUIGrid.setRendererProp(gridObj, colIdx, {"editable" : isChk});
            }
        }
    }

    // 년도 이동
    function fn_getMovYearCal(addYear) {
    	var calYear = Number($("#calYear").text()) + addYear;
    	$("#calYear").text(calYear);
    	fn_setChkEditble(false);

    	fn_selectYearCalendar(calYear);
    }

    // 데이터 저장
    function fn_saveCalendar() {
    	if(Common.confirm("<spring:message code='sys.common.alert.save'/>", function() {
    	    var saveDate = new Array();
    	    var arrayIdx = -1;

    		// 선택되어진 값을 가져온다.
    		for(var i=1; i<=12; ++i) {
    			var gridObj = eval('calGridID'+i);

                // 수정된 행 아이템들(배열)
                var editedRowItems = AUIGrid.getEditedRowColumnItems(gridObj);

                // 수정된 내역이 있는경우.
                if(editedRowItems != null && editedRowItems.length > 0) {
                	var gridColVal = '';
                	var rowIdx;

                    // 변경된 RowIndex를 가져온다.
              	    for(var z=0; z<chkArray.length; ++z) {
                        rowIdx = AUIGrid.getRowIndexesByValue(gridObj, chkArray[z], true);

                        if(rowIdx.length > 0) {
                            var colDataField = chkArray[z].replace("chk","");

                            for(var j=0; j<rowIdx.length; ++j) {
                            	// 컬럼 값을 가져온다.
                                gridColVal = AUIGrid.getCellValue(gridObj, rowIdx[j], colDataField.toLowerCase());
                                saveDate[arrayIdx = arrayIdx+1] = $("#calYear").text() + lpad(i, 2, '0') + gridColVal;  // 20191122 형태로 만들어준다.
                            }
                        }
                    }
                }
            }
    		Common.ajax("POST", "/services/serviceGroup/saveSubGroupServiceDayList.do", {"paramSaveDate": saveDate, "paramAreaId" : '${params.areaID}', "paramYear" : $("#calYear").text(),"paramSubGrpType" : '${params.subGrpType}'}, function(result) {
    			if(result.code == "99"){
                    Common.alert(" Service Date Upload "+DEFAULT_DELIMITER + result.message);
                 }else{
                     // 성공시에 부모창 재조회
                     fn_CTSubGroupSearch();
                     Common.alert(result.message, $('#_groupCalDiv').remove());
                 }
    	    });

    	}));
    }

    // DSC기준으로 전체 SubGroup에 update 한다.
    function fn_saveSubGroupCopy() {
    	Common.confirm("Do you want to all assign about Sub Group '${params.ctSubGrp}' ?" , function(){
            Common.ajax("POST", "/services/serviceGroup/saveAllSubGroupServiceDayList.do", {"paramCtSubGrp": '${params.ctSubGrp}', "paramAreaId" : '${params.areaID}', "paramYear" : $("#calYear").text(),"paramSubGrpType" : '${params.subGrpType}'}, function(result) {
                if(result.code == "000"){ // 성공
                    // 성공시에 부모창 재조회
                    fn_CTSubGroupSearch();
                    Common.alert(result.message, $('#_groupCalDiv').remove());
                }else{
                    Common.alert(" Service Date Upload "+DEFAULT_DELIMITER + result.message);
                }
            })
        });
    }

</script>


<!-- ================== Design ===================   -->
<div id="popup_wrap" class="popup_wrap size_big"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>NO Service Date</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" onclick="javascript:fn_editCalendar()">EDIT</a></p></li>
    <li><p class="btn_blue2"><a href="#" onclick="javascript:fn_saveCalendar()">SAVE</a></p></li>
    <li><p class="btn_blue2"><a href="#" onclick="javascript:fn_saveSubGroupCopy()">Sub Group Copy</a></p></li>
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
    <section class="search_table"><!-- search_table start -->
        <form action="#" method="post" id="form_currentTerritory">
            <input type="hidden" id="brnchType" name="brnchType" />
            <!-- table start -->
            <table class="type1">
                <caption>table</caption>
                <colgroup>
                    <col style="width:100px" />
                    <col style="width:250px" />
                    <col style="width:100px" />
                    <col style="width:*" />
                    <col style="width:100px" />
                    <col style="width:250px" />
                </colgroup>
                <tbody>
	                <tr>
	                   <th scope="row">Area ID</th>
                        <td><input type="text" id="areaID" name="areaID" class="w100p" value="${params.areaID}" disabled /></td>
	                    <th scope="row">Area</th>
	                    <td><input type="text" id="area" name="area" class="w100p" value="${params.area}" disabled /></td>
	                    <th scope="row">Sub Group</th>
	                    <td><input type="text" id="ctSubGrp" name="ctSubGrp" class="w100p" value="${params.ctSubGrp}" disabled /></td>
	                </tr>
                </tbody>
            </table>
            <!-- table end -->
        </form>
    </section><!-- search_table end -->

    <!-- grid_wrap start -->
	<article class="grid_wrap">
	    <div>
	       <span class="calTitle">
	           <a href="#" onclick="javascript:fn_getMovYearCal(-1);" style="font-size: 3em;" ><&nbsp;&nbsp;&nbsp;</a>
	           <a style="font-size: 3em;" id="calYear"></a>
	           <a href="#" onclick="javascript:fn_getMovYearCal(1);" style="font-size: 3em;" >&nbsp;&nbsp;&nbsp;></a>
	       </span>
	    </div>
	    <table><!-- table start -->
			<caption>table</caption>
			<colgroup>
			    <col style="width:33.3%" />
			    <col style="width:33.3%" />
			    <col style="width:*" />
			</colgroup>
			<tbody style="margin:0; padding:0; height:100%; width:100%;">
			<tr>
			    <td><div id="grid_ctMonCal01" style="width: 100%; height: 220px; margin: 0 auto;"></div></td>
			    <td><div id="grid_ctMonCal02" style="width: 100%; height: 220px; margin: 0 auto;"></div></td>
			    <td><div id="grid_ctMonCal03" style="width: 100%; height: 220px; margin: 0 auto;"></div></td>
			</tr>
			<tr>
			    <td><div id="grid_ctMonCal04" style="width: 100%; height: 220px; margin: 0 auto;"></div></td>
			    <td><div id="grid_ctMonCal05" style="width: 100%; height: 220px; margin: 0 auto;"></div></td>
			    <td><div id="grid_ctMonCal06" style="width: 100%; height: 220px; margin: 0 auto;"></div></td>
			</tr>
			<tr>
			    <td><div id="grid_ctMonCal07" style="width: 100%; height: 220px; margin: 0 auto;"></div></td>
			    <td><div id="grid_ctMonCal08" style="width: 100%; height: 220px; margin: 0 auto;"></div></td>
			    <td><div id="grid_ctMonCal09" style="width: 100%; height: 220px; margin: 0 auto;"></div></td>
			</tr>
			<tr>
			    <td><div id="grid_ctMonCal10" style="width: 100%; height: 200px; margin: 0 auto;"></div></td>
			    <td><div id="grid_ctMonCal11" style="width: 100%; height: 200px; margin: 0 auto;"></div></td>
			    <td><div id="grid_ctMonCal12" style="width: 100%; height: 200px; margin: 0 auto;"></div></td>
			</tr>
			</tbody>
        </table>
	</article>
	<!-- grid_wrap end -->
</section><!-- pop_body end -->
</div>