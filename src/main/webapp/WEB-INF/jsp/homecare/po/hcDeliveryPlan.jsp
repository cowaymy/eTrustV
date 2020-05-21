<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/homecare-js-1.0.js"></script>

<style type="text/css">
/* 커스텀 칼럼 콤보박스 스타일 정의 */
.aui-grid-drop-list-ul {
    text-align:left;
}

</style>

<script type="text/javaScript">
var toDay = "${toDay}"; // dd/MM/yyyy
var arrToDate = toDay.split('/');
var toDate = new Date(arrToDate[2], arrToDate[1], arrToDate[0]);

var oldPoNo = -1;

var cdcDs = [];
<c:forEach var="obj" items="${cdcList}">
  cdcDs.push({codeId:"${obj.codeId}", codeName:"${obj.codeName}", address:"${obj.address}", telNo:"${obj.telNo}"});
</c:forEach>

var vendorDs = [];
var vendorObj = {};
<c:forEach var="obj" items="${vendorList}">
  vendorDs.push({codeId:"${obj.codeId}", codeName:"${obj.codeName}"});
  vendorObj["${obj.codeId}"] = "${obj.codeName}";
</c:forEach>

// main grid
var mSort = {};

    //AUIGrid 생성 후 반환 ID
    var myGridID, detailGridID, planGridID;

    // AUIGrid main 칼럼 설정
    var columnLayout = [{dataField:"rnum", headerText:"No", width:50, editable:false}
            , {dataField:"cdc", headerText:"CDC", width:120}
            , {dataField:"cdcName", headerText :"CDC Name", width:250, style:"aui-grid-user-custom-left"}
            , {dataField:"poNo", headerText:"PO No", width:160}
            , {dataField:"poTyCd", visible:false}
            , {dataField:"poTyName",headerText :"PO Type", width:120}
            , {dataField:"poStsCode", visible:false}
            , {dataField:"poStsName",headerText :"Status", width:100}
            , {dataField:"suppStsCd", visible:false}
            , {dataField:"suppStsCode", visible:false}
            , {dataField:"suppStsName",headerText :"Sales Order", width:100}
            , {dataField:"memAccId", headerText:"Supplier ID", width:120}
            , {dataField:"memAccName", headerText:"Supplier Name", width:250, style:"aui-grid-user-custom-left"}
            , {dataField:"poDt", headerText:"PO Date", width:100, editable:false
                , dataType:"date"
                , dateInputFormat:"dd/mm/yyyy"  // 실제 데이터의 형식 지정
                , formatString:"dd/mm/yyyy"     // 실제 데이터 형식을 어떻게 표시할지 지정
            }
            , {dataField:"cdcDueDt", headerText:"Delivery Due Date", width:140
                , dataType:"date"
                , dateInputFormat:"dd/mm/yyyy"  // 실제 데이터의 형식 지정
                , formatString:"dd/mm/yyyy"     // 실제 데이터 형식을 어떻게 표시할지 지정
            }
            , {dataField:"address", headerText:"Address", width:300, style:"aui-grid-user-custom-left"}
            , {dataField:"tel", headerText:"Contact No", width:120}
            , {dataField:"rm", headerText:"Remark", width:300, style:"aui-grid-user-custom-left"}
            , {dataField:"planYn", headerText:"Plan Y/N", width:220}
    ];

    // main 그리드 속성 설정
    var grid_options = {
      usePaging : false,           // 페이지 설정1
      //pageRowCount : 30,         // 페이지 설정2
      //fixedColumnCount : 1,        // 틀고정(index)
      editable : false,            // 편집 가능 여부 (기본값 : false)
      enterKeyColumnBase : true,   // 엔터키가 다음 행이 아닌 다음 칼럼으로 이동할지 여부 (기본값 : false)
      selectionMode : "singleRow", // 셀 선택모드 (기본값: singleCell): (singleCell, singleRow), (multipleCells, multipleRows)
      //showSelectionBorder:true,    // (녹색 테두리 선)(기본값 : true)
      //useContextMenu : true,       // 컨텍스트 메뉴 사용 여부 (기본값 : false)
      showRowNumColumn : false,     // 그리드 넘버링
      enableFilter : true,         // 필터 사용 여부 (기본값 : false)
      //useGroupingPanel : false,    // 그룹핑 패널 사용
      //displayTreeOpen : false,     // 그룹핑 또는 트리로 만들었을 때 펼쳐지게 할지 여부 (기본값 : false)
      showStateColumn : false,      // 상태 칼럼 사용
      noDataMessage : "<spring:message code='sys.info.grid.noDataMessage' />",
      groupingMessage : "여기에 칼럼을 드래그하면 그룹핑이 됩니다.",
      rowIdField : "rnum",
      enableSorting : false,
      showRowCheckColumn : false,      // row 체크박스 표시 설정
      showRowAllCheckBox : false,      // 전체 체크박스 표시 설정
      enableRestore: true
    };

  // sub 칼럼 설정
  var subColumnLayout = [{dataField:"poNo", headerText:"PO No", width:160, editable:false}
              , {dataField:"poDtlNo", headerText:"PO Detail No", width:100, editable:false}
              , {dataField:"stockId", visible:false}
              , {dataField:"stockCode", headerText:"Material Code", width:120, editable:false}
              , {dataField:"stockName", headerText:"Material Name", width:350, editable:false, style:"aui-grid-user-custom-left"}
              , {dataField:"confirmQty", headerText:"Confirm QTY", width:100, editable:false
                  , style:"aui-grid-user-custom-right"
                    , dataType:"numeric"
                    , formatString:"#,##0"
              }
              , {dataField:"uomName", headerText:"UOM", width:100, editable:false}
              , {dataField:"exPlanQty", headerText:"Ex Plan Qty", width:100, editable:false
                  , style:"aui-grid-user-custom-right"
                    , dataType:"numeric"
                    , formatString:"#,##0"
              }
              , {dataField:"producedQty", headerText:"Produced Qty", width:100, editable:false
                  , style:"aui-grid-user-custom-right"
                    , dataType:"numeric"
                    , formatString:"#,##0"
              }
              , {dataField:"balanceQty", headerText:"Balance", width:100, editable:false
                  , style:"aui-grid-user-custom-right"
                    , dataType:"numeric"
                    , formatString:"#,##0"
              }
              , {dataField:"planQty", headerText:"Planed Qty", width:100, headerStyle:"aui-grid-header-input-icon aui-grid-header-input-essen"
                  , style:"aui-grid-user-custom-right"
                    , dataType:"numeric"
                    , formatString:"#,##0"
                    , editRenderer : {
                          type : "InputEditRenderer",
                          showEditorBtnOver : false, // 마우스 오버 시 에디터버턴 보이기
                          onlyNumeric : true, // 0~9만 입력가능
                          allowPoint : false, // 소수점( . ) 도 허용할지 여부
                          allowNegative : false, // 마이너스 부호(-) 허용 여부
                          textAlign : "right", // 오른쪽 정렬로 입력되도록 설정
                          autoThousandSeparator : false // 천단위 구분자 삽입 여부
                    }
              }

              , {dataField:"planDt", headerText:"Plan Date", width:160, headerStyle:"aui-grid-header-input-icon aui-grid-header-input-essen"
                  , dataType:"date"
                  , dateInputFormat:"dd/mm/yyyy"  // 실제 데이터의 형식 지정
                  , formatString:"dd/mm/yyyy"     // 실제 데이터 형식을 어떻게 표시할지 지정
                  , editRenderer : {
                        type:"CalendarRenderer"
                      , onlyMonthMode:false
                      , showEditorBtnOver:true
                      //, defaultFormat:"dd/mm/yyyy" // 달력 선택 시 데이터에 적용되는 날짜 형식
                      , onlyCalendar:true // 사용자 입력 불가, 즉 달력으로만 날짜입력 (기본값 : true)
                      //, openDirectly : true  // 에디팅 진입 시 바로 달력 열기
                      , onlyNumeric : false // 숫자
                  }
              }
  ];

    // sub 그리드 속성 설정
    var subGrid_options = {
    usePaging : false,           // 페이지 설정1
    //pageRowCount : 30,         // 페이지 설정2
    fixedColumnCount : 0,        // 틀고정(index)
    editable : true,             // 편집 가능 여부 (기본값 : false)
    enterKeyColumnBase : true,   // 엔터키가 다음 행이 아닌 다음 칼럼으로 이동할지 여부 (기본값 : false)
    selectionMode : "multipleRows", // 셀 선택모드 (기본값: singleCell): (singleCell, singleRow), (multipleCells, multipleRows)
    useContextMenu : true,       // 컨텍스트 메뉴 사용 여부 (기본값 : false)
    showRowNumColumn : true,     // 그리드 넘버링
    enableFilter : true,         // 필터 사용 여부 (기본값 : false)
    useGroupingPanel : false,    // 그룹핑 패널 사용
    displayTreeOpen : false,     // 그룹핑 또는 트리로 만들었을 때 펼쳐지게 할지 여부 (기본값 : false)
    showStateColumn : false,      // 상태 칼럼 사용
    noDataMessage : "<spring:message code='sys.info.grid.noDataMessage' />",
    groupingMessage : "여기에 칼럼을 드래그하면 그룹핑이 됩니다.",
    //rowIdField : "priceSeqNo",
    enableSorting : true,
    showRowCheckColumn : true,    // row checkbox
    showRowAllCheckBox : true,
    enableRestore: true,
    softRemovePolicy : "exceptNew" //사용자추가한 행은 바로 삭제
    };

    // plan 칼럼 설정
    var planColumnLayout = [{dataField:"poNo", headerText:"PO No", width:160, editable:false}
                , {dataField:"poDtlNo", headerText:"PO Detail No", width:100, editable:false}
                , {dataField:"poDtlPlanNo", headerText:"Plan No", width:100, editable:false}
                , {dataField:"stockId", editable:false, visible:false}
                , {dataField:"stockCode", headerText:"Material Code", width:120, editable:false}
                , {dataField:"stockName", headerText:"Material Name", width:350, editable:false, style:"aui-grid-user-custom-left"}
                , {dataField:"poPlanQty", headerText:"QTY", width:120, headerStyle:"aui-grid-header-input-icon aui-grid-header-input-essen"
                    , style:"aui-grid-user-custom-right"
                      , dataType:"numeric"
                      , formatString:"#,##0"
                }
                , {dataField:"poPlanDt", headerText:"Plan Due Date", width:160, headerStyle:"aui-grid-header-input-icon aui-grid-header-input-essen"
                    , dataType:"date"
                    , dateInputFormat:"dd/mm/yyyy"  // 실제 데이터의 형식 지정
                    , formatString:"dd/mm/yyyy"     // 실제 데이터 형식을 어떻게 표시할지 지정
                   	, editRenderer : {
                            type:"CalendarRenderer"
                          , onlyMonthMode:false
                          , showEditorBtnOver:true
                          //, defaultFormat:"dd/mm/yyyy" // 달력 선택 시 데이터에 적용되는 날짜 형식
                          , onlyCalendar:true // 사용자 입력 불가, 즉 달력으로만 날짜입력 (기본값 : true)
                          //, openDirectly : true  // 에디팅 진입 시 바로 달력 열기
                          , onlyNumeric : false // 숫자
                    }
                }
                , {dataField:"actualQty", headerText:"Production Qty", width:140, headerStyle:"aui-grid-header-input-icon"
                    , style:"aui-grid-user-custom-right"
                      , dataType:"numeric"
                      , formatString:"#,##0"
                      , editRenderer : {
                            type : "InputEditRenderer",
                            showEditorBtnOver : false, // 마우스 오버 시 에디터버턴 보이기
                            onlyNumeric : true, // 0~9만 입력가능
                            allowPoint : false, // 소수점( . ) 도 허용할지 여부
                            allowNegative : false, // 마이너스 부호(-) 허용 여부
                            textAlign : "right", // 오른쪽 정렬로 입력되도록 설정
                            autoThousandSeparator : false // 천단위 구분자 삽입 여부
                      }
                }
                , {dataField:"confirmQty", editable:false, visible:false}
    ];

    // 푸터 설정
    var planFooterLayout = [{labelText : "Total", positionField : "stockName"}
                       , {dataField : "poPlanQty"
                           , positionField : "poPlanQty"
                           , operation : "SUM"
                           , formatString : "#,##0"
                           , style:"aui-grid-user-custom-right"
                       }
                       , {dataField : "actualQty"
                           , positionField : "actualQty"
                           , operation : "SUM"
                           , formatString : "#,##0"
                           , style:"aui-grid-user-custom-right"
                       }
    ];

    // plan sub 그리드 속성 설정
    var planGrid_options = {
	    usePaging : false,           // 페이지 설정1
	    //pageRowCount : 30,         // 페이지 설정2
	    fixedColumnCount : 0,        // 틀고정(index)
	    editable : true,             // 편집 가능 여부 (기본값 : false)
	    enterKeyColumnBase : true,   // 엔터키가 다음 행이 아닌 다음 칼럼으로 이동할지 여부 (기본값 : false)
	    selectionMode : "multipleRows", // 셀 선택모드 (기본값: singleCell): (singleCell, singleRow), (multipleCells, multipleRows)
	    useContextMenu : true,       // 컨텍스트 메뉴 사용 여부 (기본값 : false)
	    showRowNumColumn : true,     // 그리드 넘버링
	    enableFilter : true,         // 필터 사용 여부 (기본값 : false)
	    useGroupingPanel : false,    // 그룹핑 패널 사용
	    displayTreeOpen : false,     // 그룹핑 또는 트리로 만들었을 때 펼쳐지게 할지 여부 (기본값 : false)
	    showStateColumn : false,      // 상태 칼럼 사용
	    noDataMessage : "<spring:message code='sys.info.grid.noDataMessage' />",
	    groupingMessage : "여기에 칼럼을 드래그하면 그룹핑이 됩니다.",
	    //rowIdField : "priceSeqNo",
	    showFooter : true,
	    enableSorting : true,
	    showRowCheckColumn : true,      // row checkbox
	    independentAllCheckBox : true,  // 전체 선택 체크박스가 독립적인 역할을 할지 여부
	    showRowAllCheckBox : true,      // 전체 체크박스 표시 설정
	    enableRestore: true,
	    softRemovePolicy : "exceptNew", //사용자추가한 행은 바로 삭제
	    softRemoveRowMode : false,      // 그리드 삭제시, 바로 삭제 여부 (기본값:true : 삭제여부 표시.)

	    // 엑스트라 체크박스 disabled 함수
	    // 이 함수는 렌더링 시 빈번히 호출됩니다. 무리한 DOM 작업 하지 마십시오. (성능에 영향을 미침)
	    // rowCheckDisabledFunction 이 아래와 같이 간단한 로직이라면, 실제로 rowCheckableFunction 정의가 필요 없습니다.
	    // rowCheckDisabledFunction 으로 비활성화된 체크박스는 체크 반응이 일어나지 않습니다.(rowCheckableFunction 불필요)
	    rowCheckDisabledFunction : function(rowIndex, isChecked, item) {
            var arrDt = (item.poPlanDt).split('/');
            var planDate = new Date(arrDt[0], arrDt[1], arrDt[2]);
	    	if((planDate - toDate) < 0) { // 현재일자보다 작은 경우 체크박스 disabeld 처리함
	            return false; // false 반환하면 disabled 처리됨
	        }

	    	return true;
	    }

    };

    $(document).ready(function(){

        // masterGrid 그리드를 생성합니다.
        myGridID = GridCommon.createAUIGrid("mainGrid", columnLayout, "", grid_options);
        detailGridID = GridCommon.createAUIGrid("subGrid", subColumnLayout,"", subGrid_options);
        planGridID = GridCommon.createAUIGrid("planGrid", planColumnLayout,"", planGrid_options);

        // 푸터 레이아웃 세팅
        AUIGrid.setFooter(planGridID, planFooterLayout);

        // main grid paging 표시
        GridCommon.createExtPagingNavigator(1, 0, {funcName:'getListAjax'});

        // 그리드 초기화
        AUIGrid.setGridData(myGridID, []);
        AUIGrid.setGridData(detailGridID, []);
        AUIGrid.setGridData(planGridID, []);

        // combo 내역 초기화
        doDefCombo(cdcDs, '', 'sCdc', 'S', '');
        doDefCombo(vendorDs, '', 'sMemAccId', 'S', '');

        if( js.String.isEmpty($("#sPoDtFrom").val()) ){
            $("#sPoDtFrom").val("${threeMonthBf}");
        }
        if( js.String.isEmpty($("#sPoDtTo").val()) ){
            $("#sPoDtTo").val("${toDay}");
        }

        $("#sMemAccId").val(vendorDs[0].codeId);                // 임시 처리 - 로그인 사용자의 vendor로 할 예정.
      //  $("select[name=sMemAccId]").prop('disabled',true);      // 임시 처리

        // 조회버튼
        $("#btnSearch").click(function(){
            if(js.String.isEmpty($("#sCdc").val()) || js.String.isEmpty($("#sMemAccId").val())){
                Common.alert("Please, check the mandatory value.");
                return ;
            }

		    // 날짜형식 체크
		    var sValidDtFrom = $("#sPoDtFrom").val();
		    var sValidDtTo = $("#sPoDtTo").val();

		    var date_pattern = /^(0[1-9]|[12][0-9]|3[0-1])\/(0[1-9]|1[012])\/(19|20)\d{2}$/;
		    if( !date_pattern.test(sValidDtFrom)) {
		          Common.alert("Please check the date format.");
		          return ;
		    }
		    if( !date_pattern.test(sValidDtTo)) {
		        Common.alert("Please check the date format.");
		        return ;
		    }

            var arrStDt = sValidDtFrom.split('/');
            var arrEnDt = sValidDtTo.split('/');
            var dat1 = new Date(arrStDt[2], arrStDt[1], arrStDt[0]);
            var dat2 = new Date(arrEnDt[2], arrEnDt[1], arrEnDt[0]);

            var diff = dat2 - dat1;
            if(diff < 0){
            	Common.alert("The start date can be greater than the end date.");
            	return ;
            }

            if(js.date.dateDiff(dat1, dat2) > 92){
            	Common.alert("The duration is only three months.");
                return ;
            }

		    // 메인 그리드 조회
		    getListAjax(1);

      });

        // add
        $("#btnSubAdd").click(function(){
            var items = AUIGrid.getCheckedRowItems(detailGridID);

            if(items.length < 1){
                Common.alert("Please, select a row.");
                return false;
            }

            var arrDt, planDate;
            var isBeforDate = false;
            $.each(items, function(idx, row){
                arrDt = (row.item.planDt).split('/');
                planDate = new Date(arrDt[0], arrDt[1], arrDt[2]);

                if( (planDate - toDate) < 0){
                	isBeforDate = true;
                }
            });
            if(isBeforDate){
            	Common.alert("Plan date must be greater than or equal to the current date.");
            	return false;
            }

            /*
        	Common.showLoader();
            $.ajax({
                type:"GET",
                url:"/homecare/po/selectHcDeliveryPlanPlanCnt.do",
                data : {"sPoNo":items[0].item.poNo},
                dataType : "json",
                //async:false,
                contentType : "application/json;charset=UTF-8",
                success : function(data) {
                	Common.removeLoader();
                    if(data.data > 0){
	                	Common
	                	   .confirm(
	                		   "Plan exists in the PO No. <br>Do you want to delete the existing saved plan and proceed?",
	                		   function(){
	                               Common.ajax("POST", "/homecare/po/deleteHcPoPlan.do"
	                                       , {"poNo":items[0].item.poNo}
	                                       , function(result){
	                                    	   AUIGrid.setGridData(planGridID, []);
			                            	   addPlanRow(items);
	                                        }
	                                       , function(jqXHR, textStatus, errorThrown){
	                                           try{
	                                               console.log("Fail Status : " + jqXHR.status);
	                                               console.log("code : "        + jqXHR.responseJSON.code);
	                                               console.log("message : "     + jqXHR.responseJSON.message);
	                                               console.log("detailMessage : "  + jqXHR.responseJSON.detailMessage);
	                                           }catch (e){
	                                               console.log(e);
	                                           }
	                               });

	                		   }
	                		   , function(){
	                			   addPlanRow(items);
	                		   });
                    }else{
                    	addPlanRow(items);
                    }
                },
                error : function(jqXHR, textStatus, errorThrown) {
                	Common.removeLoader();
                	if (FormUtil.isNotEmpty(jqXHR.responseJSON)) {
                        Common.setMsg("Fail : " + jqXHR.responseJSON.message);
                        Common.alert("Fail : " + jqXHR.responseJSON.message);
                    }else{
                        Common.setMsg("Fail.(common.js : ajax error)");
                        Common.alert("Fail.(common.js : ajax error)");
                    }
                }
            });
            */

            addPlanRow(items);
        });

        // del
        $("#btnPlanDel").click(function(){
            var items = AUIGrid.getCheckedRowItems(planGridID);

            if(items.length < 1){
                Common.alert("Please, select a row.");
                return false;
            }

            AUIGrid.removeRow(planGridID, items.map(function(i){ return i.rowIndex}) );

            // softRemoveRowMode 가 true 일 때 삭제를 하면 그리드 상에 마크가 되는데
            // 이를 실제로 그리드에서 삭제 함.
            //AUIGrid.removeSoftRows(planGridID);
        });

        // save
        $("#btnPlanSave").click(function(){

        	var items = AUIGrid.getGridData(planGridID);
        	if(items.length == 0){
                Common.alert("Please, Input item information.");
                return false;
            }

        	//if(!fn_ValidationCheck(items)){
        	//	return false;
        	//}

        	for (var i = 0; i < items.length; i++){
                var poNo = items[i].poNo;
                var poDtlNo = items[i].poDtlNo;
                var poPlanQty = Number(items[i].poPlanQty);
                var actualQty = Number(items[i].actualQty);

                var totQty = 0;
        		for(var j in items){
                    if(items[j].poNo == poNo && items[j].poDtlNo == poDtlNo ){
                        totQty += items[j].actualQty;
                    }
                }

        		if(totQty > Number(items[i].confirmQty) ){
        			Common.alert("Production Qty cannot be greater than Confirm Qty.");
        			return false;
        		}

                if(poPlanQty <= 0){
                    Common.alert("Qty must be greater than zero.");
                    return false;
                }
        	}


            Common
	            .confirm(
	                "<spring:message code='sys.common.alert.save'/>",
	                function(){
	                    Common.ajax("POST", "/homecare/po/multiHcPoPlan.do"
	                            , {"planData":items}
	                            , function(result){
	                                Common.alert(result.data  + "<spring:message code='sys.msg.savedCnt'/>");
	                                getListAjax(1);
	                                //console.log("성공." + JSON.stringify(result));
	                                //console.log("data : " + result.data);
	                             }
	                            , function(jqXHR, textStatus, errorThrown){
	                                try{
	                                    console.log("Fail Status : " + jqXHR.status);
	                                    console.log("code : "        + jqXHR.responseJSON.code);
	                                    console.log("message : "     + jqXHR.responseJSON.message);
	                                    console.log("detailMessage : "  + jqXHR.responseJSON.detailMessage);
	                                }catch (e){
	                                    console.log(e);
	                                }
	                                Common.alert("Fail : " + jqXHR.responseJSON.message);
	                    });
	                }
            );

        });

        // excel
        $("#btnExcel").click(function(){
        	GridCommon.exportTo("planGrid", 'xlsx',"Production Plans");
        });

        $("input[type=text]").keypress(function(event) {
            if (event.which == '13'){
                $("#btnSearch").click();
            }
        });
    });


    // 이벤트 정의
    $(function(){

        /*
        AUIGrid.bind(myGridID, "selectionChange", function( event ) {
            var selectedItems = event.selectedItems;
        });
        */

        // main grid cellClick event.
        AUIGrid.bind(myGridID, "cellClick", cellClickEvent);

        // header Click
        AUIGrid.bind(myGridID, "headerClick", function( event ) {
            console.log(event.type + " : " + event.headerText + ", dataField : " + event.dataField + ", index : " + event.columnIndex + ", depth : " + event.item.depth);
            //return false; // 정렬 실행 안함.

            var span = $(myGridID).find(".aui-grid-header-panel").find("tbody > tr > td > div")[event.columnIndex];
            if(mSort.hasOwnProperty(event.dataField)){
                if(mSort[event.dataField].dir == "asc"){
                  mSort[event.dataField] = {"field":event.dataField, "dir":"desc" };
                    $(span).removeClass("aui-grid-sorting-ascending");
                    $(span).addClass("aui-grid-sorting-descending");
                }else{
                    delete mSort[event.dataField];
                    $(span).removeClass("aui-grid-sorting-descending");
                }
            }else{
              mSort[event.dataField] = {"field":event.dataField, "dir":"asc"};
                $(span).addClass("aui-grid-sorting-ascending");
            }

            getListAjax(1);
        });

        // 행 추가 이벤트 바인딩
        AUIGrid.bind(planGridID, "addRow", function(e){
            //console.log(e.type + " 이벤트 :  " + "삽입된 행 인덱스 : " + e.rowIndex + ", 삽입된 행 개수 : " + e.items.length);
            var gData = AUIGrid.getGridData(planGridID);

            for(var i in e.items){
            	var poNo = e.items[i].poNo;
            	var poDtlNo = e.items[i].poDtlNo;

            	var totQty = 0;
            	for(var j in gData){
            		if(poNo == gData[j].poNo && poDtlNo == gData[j].poDtlNo){
            			totQty += Number(gData[j].poPlanQty);
            		}
            	}

                var rows = AUIGrid.getRowIndexesByValue(detailGridID, "poDtlNo", poDtlNo);
                AUIGrid.setCellValue(detailGridID, rows, "exPlanQty", totQty);

                var confirmQty = Number(AUIGrid.getCellValue(detailGridID, rows, "confirmQty"));
                //AUIGrid.setCellValue(detailGridID, rows, "planQty", (confirmQty-totQty)>=0?(confirmQty-totQty):0);
                AUIGrid.setCellValue(detailGridID, rows, "planQty", 0);
            }
        });

        // 행 삭제 이벤트 바인딩
        AUIGrid.bind(planGridID, "removeRow", function(e){
            //console.log(e.type + " 이벤트 :  " + ", 삭제된 행 개수 : " + e.items.length + ", softRemoveRowMode : " + e.softRemoveRowMode);

            for(var i in e.items){
            	var poNo = e.items[i].poNo;
                var poDtlNo = e.items[i].poDtlNo;
                var planQty = Number(e.items[i].poPlanQty);
                var actualQty = Number(e.items[i].actualQty);

                var rows = AUIGrid.getRowIndexesByValue(detailGridID, "poDtlNo", poDtlNo);
                var exPlan = Number(AUIGrid.getCellValue(detailGridID, rows, "exPlanQty"));
                var confirmQty = Number(AUIGrid.getCellValue(detailGridID, rows, "confirmQty"));

                AUIGrid.setCellValue(detailGridID, rows, "exPlanQty", exPlan - planQty);
                //AUIGrid.setCellValue(detailGridID, rows, "planQty", confirmQty - (exPlan - planQty)>=0?confirmQty - (exPlan - planQty):0);

                // producedQty
                var produced = Number(AUIGrid.getCellValue(detailGridID, rows, "producedQty"));
                AUIGrid.setCellValue(detailGridID, rows, "producedQty", produced - actualQty);

                // balanceQty
                AUIGrid.setCellValue(detailGridID, rows, "balanceQty", confirmQty-(produced - actualQty) );
            }
        });

        AUIGrid.bind(planGridID, "cellEditBegin", function(event){
        	if ( event.dataField == "poPlanQty"
                || event.dataField == "poPlanDt"
                || event.dataField == "actualQty"
               ){
                  // 신규 row만 수정가능.
                  //if(!AUIGrid.isAddedById(myGridID, event.item.pid)){
                  //    return true;
                  //}

                  var selectItem = AUIGrid.getSelectedItems(planGridID);
                  if(selectItem.length == 0){
                      return false;
                  }

                  var arrDueDate = (selectItem[0].item.poPlanDt).split('/');
                  var dueDate = new Date(arrDueDate[0], arrDueDate[1], arrDueDate[2]);

                  if( (dueDate - toDate) < 0 ){
                      return false;
                  }
             }
        });

        AUIGrid.bind(planGridID, "cellEditEnd", function(event){
        	if ( event.dataField == "poPlanDt"){
        	    var arrDate = (event.item.poPlanDt).split('/');
        	    var planDate = new Date(arrDate[0], arrDate[1], arrDate[2]);
        	    if( (planDate - toDate) < 0 ){
        	    	Common.alert("Plan date cannot be less than current date.");
        	    	AUIGrid.setCellValue(planGridID, event.rowIndex, "poPlanDt", js.String.isNotEmpty(event.oldValue)?event.oldValue:arrToDate[2]+"/"+arrToDate[1]+"/"+arrToDate[0]);
        	    }
        	}
        	if ( event.dataField == "poPlanQty"){
                var poNo = event.item.poNo;
                var poDtlNo = event.item.poDtlNo;
        		var diff = js.String.naNcheck(event.oldValue) - js.String.naNcheck(event.value);

        		var rows = AUIGrid.getRowIndexesByValue(detailGridID, "poDtlNo", poDtlNo);
        		var exPlan = Number(AUIGrid.getCellValue(detailGridID, rows, "exPlanQty"));
        		var confirmQty = Number(AUIGrid.getCellValue(detailGridID, rows, "confirmQty"));

        		AUIGrid.setCellValue(detailGridID, rows, "exPlanQty", exPlan - diff);
                //AUIGrid.setCellValue(detailGridID, rows, "planQty", confirmQty - (exPlan - diff)>=0?confirmQty - (exPlan - diff):0);
        	}

        	if ( event.dataField == "actualQty"){
                var poNo = event.item.poNo;
                var poDtlNo = event.item.poDtlNo;
                var diff = js.String.naNcheck(event.oldValue) - js.String.naNcheck(event.value);

                var rows = AUIGrid.getRowIndexesByValue(detailGridID, "poDtlNo", poDtlNo);
                var produced = Number(AUIGrid.getCellValue(detailGridID, rows, "producedQty"));

                AUIGrid.setCellValue(detailGridID, rows, "producedQty", produced - diff);

                var balance = Number(AUIGrid.getCellValue(detailGridID, rows, "balanceQty"));
                AUIGrid.setCellValue(detailGridID, rows, "balanceQty", balance + diff);
        	}

        });

        // 전체 체크박스 클릭 이벤트 바인딩 - 엑스트라 체크
        AUIGrid.bind(planGridID, "rowAllChkClick", function( event ) {
            if(event.checked) {
                var uniqueValues = AUIGrid.getColumnDistinctValues(event.pid, "poPlanDt");
                var planDtValues = [];
                planDtValues = planDtValues.concat(uniqueValues);

                // 현재일자보다 작은것은 체크 안함
                var arrPlan, plandt;
                for(var i in planDtValues){
                	arrPlan = planDtValues[i].split('/');
                	plandt = new Date(arrPlan[0], arrPlan[1], arrPlan[2]);
                	if( (plandt - toDate) < 0){
                		uniqueValues.splice(uniqueValues.indexOf(planDtValues[i]), 1);
                	}
                }

                AUIGrid.setCheckedRowsByValue(event.pid, "poPlanDt", uniqueValues);
            } else {
                AUIGrid.setCheckedRowsByValue(event.pid, "poPlanDt", []);
            }
        });

    });


//--function--//

function addPlanRow(items){
	for(var i in items){
		if(Number(items[i].item.planQty) > 0){
	        var data = {};
	        data["poNo"] = items[i].item.poNo;
	        data["poDtlNo"] = items[i].item.poDtlNo;
	        data["stockId"] = items[i].item.stockId;
	        data["stockCode"] = items[i].item.stockCode;
	        data["stockName"] = items[i].item.stockName;
	        data["poPlanQty"] = items[i].item.planQty;
	        data["poPlanDt"] = items[i].item.planDt;
	        data["actualQty"] = 0;
	        data["confirmQty"] = items[i].item.confirmQty;
	        AUIGrid.addRow(planGridID, data, "last");
		}
    }
}

// main grid cellClick event.
function cellClickEvent( event ){
    console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
    //var gSelRowIdx = event.rowIndex;

      // 그리드 선택 block을 잡아준다.
    //AUIGrid.setSelectionBlock(myGridID, event.rowIndex, event.rowIndex, 0, event.columnIndex);
      var poNo = AUIGrid.getCellValue(myGridID, event.rowIndex, 3);
      if(poNo != oldPoNo){
        AUIGrid.setGridData(detailGridID, []);
        AUIGrid.setGridData(planGridID, []);

        if(js.String.isEmpty(poNo)){
          oldPoNo = poNo;
          return false;
        }

        var subParam = {"sPoNo":poNo};
        Common.ajax("GET", "/homecare/po/selectHcDeliveryPlanSubList.do"
                , subParam
                , function(result){
                       //console.log("data : " + result);
                       AUIGrid.setGridData(detailGridID, result.dataList);
        });

        var subParam = {"sPoNo":poNo};
        Common.ajax("GET", "/homecare/po/selectHcDeliveryPlanPlan.do"
                , subParam
                , function(result){
                       //console.log("data : " + result);
                       AUIGrid.setGridData(planGridID, result.dataList);
        });

     }
     oldPoNo = poNo;
};


// 메인 그리드 조회
function getListAjax(goPage) {
    var url = "/homecare/po/selectHcDeliveryPlanMainList.do";

    var param = $("#searchForm").serializeObject();
    param.sMemAccId = $("#sMemAccId").val();

    var sortList = [];
    $.each(mSort, function(idx, row){
        sortList.push(row);
    });

    param = $.extend(param, {"rowCount":25, "goPage":goPage}, {"sort":sortList});
    console.log("param : ", param);

    // 초기화
    oldPoNo = -1;
    AUIGrid.setGridData(myGridID, []);

    Common.ajax("POST" , url , param, function(data){
        // 그리드 페이징 네비게이터 생성
        GridCommon.createExtPagingNavigator(goPage, data.total, {funcName:'getListAjax'});

        AUIGrid.setGridData(myGridID, data.dataList);
        AUIGrid.setGridData(detailGridID, []);
        AUIGrid.setGridData(planGridID, []);

        if(data.total > 0){
	        // 행을 선택해줌.
	        AUIGrid.setSelectionByIndex(myGridID, 0);
	        cellClickEvent({"rowIndex":0, "columnIndex":0});
        }
    });

}

function fn_ValidationCheck(items){
	var result = true;

    for (var i = 0; i < items.length; i++){
        var poNo = items[i].poNo;
        var poDtlNo = items[i].poDtlNo;
        var poPlanQty = Number(items[i].poPlanQty);

        var totQty = 0;
        for(var j in items){
            if(items[j].poNo == poNo && items[j].poDtlNo == poDtlNo ){
                totQty += items[j].poPlanQty;
            }
        }

        if(totQty != Number(items[i].confirmQty)){
        	result = false;
        	Common.alert("Confirm Qty must be the same as Plan Qty.");
            break;
        }

        if(totQty <= 0){
        	result = false;
            Common.alert("Qty must be greater than zero.");
            break;
        }

        if(poPlanQty <= 0){
        	result = false;
            Common.alert("Qty must be greater than zero.");
            break;
        }
    }

    return result;
}


/**
* dd-mm-yyyy 날짜 형식을 체크함.
*/
function fn_isDateValidate(sValidDt){
  // 날짜형식 체크
    var date_pattern = /^(0[1-9]|[12][0-9]|3[0-1])\/(0[1-9]|1[012])\/(19|20)\d{2}$/;
    if( sValidDt != null && sValidDt != ""
        && !date_pattern.test(sValidDt)
    ) {
        return false;
    }
    return true;
}



</script>

<section id="content"><!-- content start -->
  <ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Homecare</li>
    <li>PO</li>
    <li>POManager</li>
  </ul>


  <aside class="title_line"><!-- title_line start -->
    <p class="fav"><a href="#none" class="click_add_on">My menu</a></p>
    <h2>Production Plans</h2>

    <ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcView == 'Y'}">
      <li><p class="btn_blue"><a id="btnSearch"><span class="search"></span>Search</a></p></li>
    </c:if>
    </ul>
  </aside><!-- title_line end -->



    <section class="search_table"><!-- search_table start -->
    <form id="searchForm" method="post" onsubmit="return false;">
        <table summary="search table" class="type1"><!-- table start -->
            <caption>search table</caption>
            <colgroup>
                <col style="width:140px" />
                <col style="width:*" />
                <col style="width:140px" />
                <col style="width:*" />
                <col style="width:150px" />
                <col style="width:*" />
            </colgroup>
            <tbody>
                <tr>
                    <th scope="row"><span style="color:red">*</span>CDC</th>
                    <td>
                        <select id="sCdc" name="sCdc" placeholder="" class="w100p" >
                    </td>
                    <th scope="row"><span style="color:red">*</span>PO Date</th>
                    <td>
                        <div class="date_set w100p">
                                <!-- date_set start -->
                                <p>
                                    <input id="sPoDtFrom" name="sPoDtFrom" type="text"
                                        title="PO start Date" placeholder="DD/MM/YYYY" class="j_date">
                                </p>
                                <span> To </span>
                                <p>
                                    <input id="sPoDtTo" name="sPoDtTo" type="text"
                                        title="PO End Date" placeholder="DD/MM/YYYY" class="j_date">
                                </p>
                            </div>
                    </td>
                    <th scope="row"><span style="color:red">*</span>Supplier</th>
                    <td>
                        <select id="sMemAccId" name="sMemAccId" title="" placeholder="" class="w100p" >
                    </td>
                </tr>

                <tr>
                    <th scope="row">PO No</th>
                    <td >
                        <input type="text" id="sPoNo" name="sPoNo" placeholder="" class="w100p" >
                    </td>
                    <th scope="row">PLAN Y/N</th>
                    <td>
                        <select class="w100p" id="sPlanYn" name="sPlanYn" >
                            <option value="" selected></option>
                            <option value="Y">Y</option>
                            <option value="N">N</option>
                        </select>
                    </td>
                    <td colspan="2"></td>
                </tr>
            </tbody>
        </table><!-- table end -->
    </form>
    </section><!-- search_table end -->

  <section class="search_result"><!-- search_result start -->
	<aside class="title_line"><!-- title_line start -->
        <h3>PO list</h3>
	    <ul class="right_btns">
	    </ul>
	</aside><!-- title_line end -->

    <article class="grid_wrap"><!-- grid_wrap start -->
        <!-- 그리드 영역1 -->
        <div id="mainGrid" style="height:250px;"></div>

	    <!-- 그리드 페이징 네비게이터 -->
	    <div id="grid_paging" class="aui-grid-paging-panel my-grid-paging-panel"></div>
    </article><!-- grid_wrap end -->


    <aside class="title_line"><!-- title_line start -->
        <h3>PO Detail List</h3>
        <ul class="right_btns">
            <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
                <li><p class="btn_grid"><a id="btnSubAdd">Add</a></p></li>
            </c:if>
        </ul>
    </aside><!-- title_line end -->
    <article class="grid_wrap" ><!-- grid_wrap start -->
        <!--  그리드 영역2  -->
        <div id="subGrid" style="height:250px;"></div>
    </article><!-- grid_wrap end -->

    <aside class="title_line"><!-- title_line start -->
        <h3>Plan</h3>
        <ul class="right_btns">
            <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
	            <li><p class="btn_grid"><a id="btnExcel">Excel</a></p></li>
            </c:if>
            <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
	            <li><p class="btn_grid"><a id="btnPlanDel">Del</a></p></li>
	            <li><p class="btn_grid"><a id="btnPlanSave">Save</a></p></li>
            </c:if>
        </ul>
    </aside><!-- title_line end -->
    <article class="grid_wrap" ><!-- grid_wrap start -->
        <!--  그리드 영역2  -->
        <div id="planGrid" style="height:200px;"></div>
    </article><!-- grid_wrap end -->
  </section><!-- search_result end -->

</section><!-- content end -->
