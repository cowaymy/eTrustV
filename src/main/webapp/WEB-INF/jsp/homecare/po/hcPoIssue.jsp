<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/homecare-js-1.0.js"></script>

<style type="text/css">

/* 커스텀 칼럼 콤보박스 스타일 정의 */
.aui-grid-drop-list-ul {
    text-align:left;
}

</style>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>
<script type="text/javaScript">


var MEM_TYPE  = '${SESSION_INFO.userTypeId}';
//var userAccId = '${SESSION_INFO}';

var gAddRowCnt = 0;
var oldPoNo = -1;

//main grid sort
var mSort = {};

var cdcDs = [];
var cdcObj = {};
<c:forEach var="obj" items="${cdcList}">
  cdcDs.push({codeId:"${obj.codeId}", codeCd:"${obj.codeCd}", codeName:"${obj.codeName}", codeNames:"("+"${obj.codeCd}"+")"+"${obj.codeName}",  address:"${obj.address}", telNo:"${obj.telNo}", code:"${obj.code}"});
  cdcObj["${obj.codeId}"] = {codeId:"${obj.codeId}", codeCd:"${obj.codeCd}", codeName:"${obj.codeName}", address:"${obj.address}", telNo:"${obj.telNo}", code:"${obj.code}"};
</c:forEach>

var vendorDs = [];
var vendorObj = {};
<c:forEach var="obj" items="${vendorList}">
  vendorDs.push({codeId:"${obj.codeId}", codeName:"${obj.codeName}", codeNames:"("+"${obj.codeId}"+")"+"${obj.codeName}"});
  vendorObj["${obj.codeId}"] = "${obj.codeName}";
</c:forEach>

var poTypeDs = [];
var poTypeObj = {};
<c:forEach var="obj" items="${poTypeList}">
  poTypeDs.push({codeId:"${obj.codeId}", codeName:"${obj.codeName}", code:"${obj.code}"});
  poTypeObj["${obj.codeId}"] = "${obj.codeName}";
</c:forEach>

var poStatDs = [];
var poStatObj = {};
<c:forEach var="obj" items="${poStatList}">
  poStatDs.push({codeId:"${obj.codeId}", codeName:"${obj.codeName}", code:"${obj.code}"});
  poStatObj["${obj.codeId}"] = "${obj.codeName}";
</c:forEach>

var uomDs = [];
<c:forEach var="obj" items="${uomList}">
  uomDs.push({codeId:"${obj.codeId}", codeName:"${obj.codeName}", code:"${obj.code}"});
</c:forEach>

var curDs = [];
var curObj = {};
<c:forEach var="obj" items="${curList}">
  curDs.push({codeId:"${obj.codeId}", codeName:"${obj.codeName}", code:"${obj.code}"});
  curObj["${obj.codeId}"] = "${obj.codeName}";
</c:forEach>

var taxDs = [];
var taxObj = {};
<c:forEach var="obj" items="${taxList}">
  taxDs.push({codeId:"${obj.codeId}", codeName:"${obj.codeName}", code:"${obj.code}"});
  taxObj["${obj.codeId}"] = {codeId:"${obj.codeId}", codeName:"${obj.codeName}", code:"${obj.code}"};
</c:forEach>

    //AUIGrid 생성 후 반환 ID
    var myGridID, detailGridID;

    // AUIGrid main 칼럼 설정
    var columnLayout = [{dataField:"cdc", editable:false, visible:false}
             , {dataField:"cdcCd", headerText :"CDC", width:100, editable:false}
             , {dataField:"cdcText",headerText :"CDC Name", width:220, headerStyle:"aui-grid-header-input-icon aui-grid-header-input-essen", style:"aui-grid-user-custom-left"
            	   ,labelFunction : function(rowIndex, columnIndex, value, headerText, item ) {
	            		return cdcObj[value]==null?"":js.String.strNvl(cdcObj[value].codeName);
	               }
	               ,editRenderer : {
	                    type : "DropDownListRenderer",
	                    //showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
	                    list : cdcDs,
	                    keyField : "codeId",        // key 에 해당되는 필드명
	                    valueField : "codeNames"    // value 에 해당되는 필드명
	               }
            }
            , {dataField:"poNo", headerText:"Po No", width:160, editable:false}
            , {dataField:"poTyCd", headerText:"Po Type", width:120, headerStyle:"aui-grid-header-input-icon", editable:false, visible:false
                  ,labelFunction : function(rowIndex, columnIndex, value, headerText, item ) {
                	    return poTypeObj[value]==null?"":js.String.strNvl(poTypeObj[value]);
                   }
                  ,editRenderer : {
						type : "DropDownListRenderer",
						showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
						list : poTypeDs,
						keyField : "codeId",        // key 에 해당되는 필드명
						valueField : "codeName"    // value 에 해당되는 필드명
                  }
            }
            , {dataField:"poStsCode", editable:false, visible:false}
            , {dataField:"poStsName",headerText :"Status", width:100, editable:false}
            , {dataField:"suppStsCode", editable:false, visible:false}
            , {dataField:"suppStsName",headerText :"Sales Order", width:100, editable:false}

            , {dataField:"memAccId", headerText:"Supplier ID", width:120, editable:false}
            , {dataField:"memAccName", headerText:"Supplier Name", width:250, headerStyle:"aui-grid-header-input-icon aui-grid-header-input-essen"
            	   , style:"aui-grid-user-custom-left"
            	   , labelFunction:function(rowIndex, columnIndex, value, headerText, item ) {
                      return js.String.strNvl(vendorObj[value]);
                   }
                   , editRenderer : {
                        type:"DropDownListRenderer"
                      , showEditorBtnOver:true // 마우스 오버 시 에디터버턴 보이기
                      , list:vendorDs
                      , keyField:"codeId"        // key 에 해당되는 필드명
                      , valueField:"codeNames"   // value 에 해당되는 필드명
                   }
            }
            , {dataField:"poDt", headerText:"PO Date", width:100, editable:false
            	, dataType:"date"
                , dateInputFormat:"dd/mm/yyyy"  // 실제 데이터의 형식 지정
                , formatString:"dd/mm/yyyy"     // 실제 데이터 형식을 어떻게 표시할지 지정
            }
            , {dataField:"cdcDueDt", headerText:"Delivery Due Date", width:160, headerStyle:"aui-grid-header-input-icon aui-grid-header-input-essen"
            	, dataType:"date"
            	, dateInputFormat:"dd/mm/yyyy"  // 실제 데이터의 형식 지정
                , formatString:"dd/mm/yyyy"     // 실제 데이터 형식을 어떻게 표시할지 지정
                , editRenderer : {
                      type:"CalendarRenderer"
                    , onlyMonthMode:false
                    , showEditorBtnOver:true
                    //, defaultFormat:"dd/mm/yyyy" // 달력 선택 시 데이터에 적용되는 날짜 형식
                    , onlyCalendar:true // 사용자 입력 불가, 즉 달력으로만 날짜입력 (기본값 : true)
                    , maxlength:10 // 10자리 이하만 입력 가능
                    //, openDirectly : true  // 에디팅 진입 시 바로 달력 열기
                    , onlyNumeric : false // 숫자
                    , validator : function(oldValue, newValue, rowItem) { // 에디팅 유효성 검사
                        var isValid = true;
                        var pattern = /^(0[1-9]|[12][0-9]|3[0-1])\/(0[1-9]|1[012])\/(19|20)\d{2}$/;
                        if(js.String.isNotEmpty(newValue) && !pattern.test(newValue)) {
                            isValid = false;
                        }
                         //리턴값은 Object 이며 validate 의 값이 true 라면 패스, false 라면 message 를 띄움
                        return { "validate":isValid, "message":"10자리, 01/02/2019 형식으로 입력해주세요." };
                    }
                }
            }
            , {dataField:"address", headerText:"Address", width:400, style:"aui-grid-user-custom-left", editable:false}
            , {dataField:"telNo", headerText:"Contact No", width:120, editable:false}
            , {dataField:"rm", headerText:"Remark", width:300, style:"aui-grid-user-custom-left", headerStyle:"aui-grid-header-input-icon"
                , editRenderer : {
                	type : "InputEditRenderer",
                	maxlength : 120
                }
            }
            , {dataField:"baseExr", editable:false, visible:false}
            , {dataField:"cur", editable:false, visible:false}
            , {dataField:"issueUsrId", headerText:"Issue User Id", width:120, editable:false}
            , {dataField:"issueUsrName", headerText:"Issue User Name", width:140, editable:false, style:"aui-grid-user-custom-left"}
            , {dataField:"issueDt", headerText:"Issue Date", width:100, editable:false
            	, dataType:"date"
                , dateInputFormat:"dd/mm/yyyy"  // 실제 데이터의 형식 지정
                , formatString:"dd/mm/yyyy"     // 실제 데이터 형식을 어떻게 표시할지 지정
            }
            , {dataField:"issueRsn", headerText:"Issue Reason", width:300, editable:false, style:"aui-grid-user-custom-left"}
            , {dataField:"apprUsrId", headerText:"Approver Id", width:120, editable:false}
            , {dataField:"apprUsrName", headerText:"Approver Name", width:140, editable:false, style:"aui-grid-user-custom-left"}
            , {dataField:"apprDt", headerText:"Approve Date", width:120, editable:false
                , dataType:"date"
                , dateInputFormat:"dd/mm/yyyy"  // 실제 데이터의 형식 지정
                , formatString:"dd/mm/yyyy"     // 실제 데이터 형식을 어떻게 표시할지 지정
            }
            , {dataField:"apprRsn", headerText:"Approve Reason", width:300, editable:false, style:"aui-grid-user-custom-left"}
            , {dataField:"crtDt", headerText :"create date", width:120, editable:false
                , dataType:"date"
                , formatString:"dd/mm/yyyy"     // 실제 데이터 형식을 어떻게 표시할지 지정
                , dateInputFormat:"dd/mm/yyyy"  // 실제 데이터의 형식 지정
            }
            , {dataField: "crtUserId", headerText :"Creator", width:120, editable:false}
            , {dataField: "code", editable:false, visible:false}
    ];

    // main 그리드 속성 설정
    var grid_options = {
      usePaging : false,           // 페이지 설정1
      //pageRowCount : 30,         // 페이지 설정2
      //fixedColumnCount : 0,        // 틀고정(index)
      editable : true,             // 편집 가능 여부 (기본값 : false)
      enterKeyColumnBase : true,   // 엔터키가 다음 행이 아닌 다음 칼럼으로 이동할지 여부 (기본값 : false)
      selectionMode : "singleRow", // 셀 선택모드 (기본값: singleCell): (singleCell, singleRow), (multipleCells, multipleRows)
      //showSelectionBorder:true,    // (녹색 테두리 선)(기본값 : true)
      //useContextMenu : true,       // 컨텍스트 메뉴 사용 여부 (기본값 : false)
      showRowNumColumn : true,     // 그리드 넘버링
      enableFilter : true,         // 필터 사용 여부 (기본값 : false)
      //useGroupingPanel : false,    // 그룹핑 패널 사용
      //displayTreeOpen : false,     // 그룹핑 또는 트리로 만들었을 때 펼쳐지게 할지 여부 (기본값 : false)
      showStateColumn : true,      // 상태 칼럼 사용
      noDataMessage : "<spring:message code='sys.info.grid.noDataMessage' />",
      groupingMessage : "여기에 칼럼을 드래그하면 그룹핑이 됩니다.",
      //rowIdField : "poNo",
      enableSorting : false,
      showRowCheckColumn : false,    // row checkbox
      enableRestore: true,
      softRemovePolicy : "exceptNew" //사용자추가한 행은 바로 삭제
    };

    // sub 칼럼 설정
	var subColumnLayout = [{dataField:"poNo", headerText:"PO No", width:160, editable:false}
              , {dataField:"poDtlNo", headerText:"PO Detail No", width:100, editable:false}
              , {dataField:"stockId", editable:false, visible:false}
              , {dataField:"stockCode", headerText:"Material Code", width:120, editable:false}
              , {dataField:"stockName", headerText:"Material Name", width:300, style:"aui-grid-user-custom-left", editable:false}
              , {dataField:"poQty", headerText:"PO QTY", width:100, headerStyle:"aui-grid-header-input-icon aui-grid-header-input-essen"
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
              , {dataField:"uom", headerText:"UOM", width:100, editable:false
            	  <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
            	    , headerStyle:"aui-grid-header-input-essen"
            	  </c:if>
            	    ,labelFunction : function(rowIndex, columnIndex, value, headerText, item ) {
                        var retStr = "";
                        for(var i=0, len=uomDs.length; i<len; i++) {
                            if(uomDs[i]["codeId"] == value) {
                                retStr = uomDs[i]["codeName"];
                                break;
                            }
                        }
                        return retStr;
                    }
              }
              , {dataField:"poUprc", headerText:"PO Price", width:120
            	  <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
            	    , headerStyle:"aui-grid-header-input-icon aui-grid-header-input-essen"
                  </c:if>
            	    , style:"aui-grid-user-custom-right"
                    , dataType:"numeric"
                    , formatString:"#,##0.00"
                   	, editRenderer : {
	                    type : "InputEditRenderer",
	                    showEditorBtnOver : false, // 마우스 오버 시 에디터버턴 보이기
	                    onlyNumeric : true, // 0~9만 입력가능
	                    allowPoint : true, // 소수점( . ) 도 허용할지 여부
	                    allowNegative : false, // 마이너스 부호(-) 허용 여부
	                    textAlign : "right", // 오른쪽 정렬로 입력되도록 설정
	                    autoThousandSeparator : false // 천단위 구분자 삽입 여부
                    }
              }
              , {dataField:"suplyPrc", headerText:"Supply Price", width:140
            	  <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
            	    , headerStyle:"aui-grid-header-input-icon aui-grid-header-input-essen"
                  </c:if>
            	    , style:"aui-grid-user-custom-right"
                    , dataType:"numeric"
                    , formatString:"#,##0.00"
                    , editRenderer : {
	                    type : "InputEditRenderer",
	                    showEditorBtnOver : false, // 마우스 오버 시 에디터버턴 보이기
	                    onlyNumeric : true, // 0~9만 입력가능
	                    allowPoint : true, // 소수점( . ) 도 허용할지 여부
	                    allowNegative : false, // 마이너스 부호(-) 허용 여부
	                    textAlign : "right", // 오른쪽 정렬로 입력되도록 설정
	                    autoThousandSeparator : false // 천단위 구분자 삽입 여부
                     }
              }
              , {dataField:"tax", headerText:"Tax", width:120
                  <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
            	    , headerStyle:"aui-grid-header-input-essen"
                  </c:if>
            	    , editable:false
            	    , style:"aui-grid-user-custom-right"
                    , dataType:"numeric"
                    , formatString:"#,##0.00"
                    , editRenderer : {
                        type : "InputEditRenderer",
                        showEditorBtnOver : false, // 마우스 오버 시 에디터버턴 보이기
                        onlyNumeric : true, // 0~9만 입력가능
                        allowPoint : true, // 소수점( . ) 도 허용할지 여부
                        allowNegative : false, // 마이너스 부호(-) 허용 여부
                        textAlign : "right", // 오른쪽 정렬로 입력되도록 설정
                        autoThousandSeparator : false // 천단위 구분자 삽입 여부
                     }
              }
              , {dataField:"taxCd", headerText:"Tax Text", width:100
                  <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
            	    , headerStyle:"aui-grid-header-input-icon"
                  </c:if>
            	    , labelFunction:function(rowIndex, columnIndex, value, headerText, item ) {
                      return taxObj[value]==null?"":js.String.strNvl(taxObj[value].codeName);
                    }
                    , editRenderer : {
                        type:"DropDownListRenderer"
                      , showEditorBtnOver:true // 마우스 오버 시 에디터버턴 보이기
                      , list:taxDs
                      , keyField:"codeId"        // key 에 해당되는 필드명
                      , valueField:"codeName"    // value 에 해당되는 필드명
                    }
              }
              , {dataField:"total", headerText:"Total", width:140, editable:false, headerStyle:"aui-grid-header-input-essen"
                    , style:"aui-grid-user-custom-right"
                    , dataType:"numeric"
                    , formatString:"#,##0.00"
                    , editRenderer : {
                        type : "InputEditRenderer",
                        showEditorBtnOver : false, // 마우스 오버 시 에디터버턴 보이기
                        onlyNumeric : true, // 0~9만 입력가능
                        allowPoint : true, // 소수점( . ) 도 허용할지 여부
                        allowNegative : false, // 마이너스 부호(-) 허용 여부
                        textAlign : "right", // 오른쪽 정렬로 입력되도록 설정
                        autoThousandSeparator : false // 천단위 구분자 삽입 여부
                     }
              }
              , {dataField:"cur", headerText:"Currency", width:120
            	  <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
            	   , headerStyle:"aui-grid-header-input-icon aui-grid-header-input-essen"
                  </c:if>
            	   , labelFunction:function(rowIndex, columnIndex, value, headerText, item ) {
                      return curObj[value]==null?"":js.String.strNvl(curObj[value]);
                   }
                   , editRenderer : {
                        type:"DropDownListRenderer"
                      , showEditorBtnOver:true // 마우스 오버 시 에디터버턴 보이기
                      , list:curDs
                      , keyField:"codeId"        // key 에 해당되는 필드명
                      , valueField:"codeName"    // value 에 해당되는 필드명
                   }
              }
              , {dataField:"frexAmt", headerText:"Fx Price", width:120
                  <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
            	    , headerStyle:"aui-grid-header-input-icon"
                  </c:if>
            	    , style:"aui-grid-user-custom-right"
                    , dataType:"numeric"
                    , formatString:"#,##0.00"
              }
	];

    // sub 그리드 속성 설정
    var subGrid_options = {
		usePaging : false,           // 페이지 설정1
		//pageRowCount : 30,         // 페이지 설정2
		fixedColumnCount : 0,        // 틀고정(index)
		editable : true,             // 편집 가능 여부 (기본값 : false)
		enterKeyColumnBase : true,   // 엔터키가 다음 행이 아닌 다음 칼럼으로 이동할지 여부 (기본값 : false)
		selectionMode : "singleRow", // 셀 선택모드 (기본값: singleCell): (singleCell, singleRow), (multipleCells, multipleRows)
		useContextMenu : true,       // 컨텍스트 메뉴 사용 여부 (기본값 : false)
		showRowNumColumn : true,     // 그리드 넘버링
		enableFilter : true,         // 필터 사용 여부 (기본값 : false)
		useGroupingPanel : false,    // 그룹핑 패널 사용
		displayTreeOpen : false,     // 그룹핑 또는 트리로 만들었을 때 펼쳐지게 할지 여부 (기본값 : false)
		showStateColumn : true,      // 상태 칼럼 사용
		noDataMessage : "<spring:message code='sys.info.grid.noDataMessage' />",
		groupingMessage : "여기에 칼럼을 드래그하면 그룹핑이 됩니다.",
		//rowIdField : "priceSeqNo",
		showFooter : true,
		enableSorting : true,
		showRowCheckColumn : false,    // row checkbox
		enableRestore: true,
		softRemovePolicy : "exceptNew" //사용자추가한 행은 바로 삭제
    };

    // 푸터 설정
    var subFooterLayout = [{labelText : "Total", positionField : "stockName"}
                       , {dataField : "poQty"
                           , positionField : "poQty"
                           , operation : "SUM"
                           , formatString : "#,##0"
                           , style:"aui-grid-user-custom-right"
                       }
                       , {dataField : "poUprc"
                           , positionField : "poUprc"
                           , operation : "SUM"
                           , formatString : "#,##0.00"
                           , style:"aui-grid-user-custom-right"
                       }
                       , {dataField : "suplyPrc"
                           , positionField : "suplyPrc"
                           , operation : "SUM"
                           , formatString : "#,##0.00"
                           , style:"aui-grid-user-custom-right"
                       }
                       , {dataField : "total"
                           , positionField : "total"
                           , operation : "SUM"
                           , formatString : "#,##0.00"
                           , style:"aui-grid-user-custom-right"
                       }
                       , {dataField : "frexAmt"
                           , positionField : "frexAmt"
                           , operation : "SUM"
                           , formatString : "#,##0.00"
                           , style:"aui-grid-user-custom-right"
                       }
    ];


    $(document).ready(function(){

        // masterGrid 그리드를 생성합니다.
        myGridID = GridCommon.createAUIGrid("mainGrid", columnLayout, "", grid_options);
        detailGridID = GridCommon.createAUIGrid("subGrid", subColumnLayout,"", subGrid_options);

         // 푸터 레이아웃 세팅
        AUIGrid.setFooter(detailGridID, subFooterLayout);

        // main grid paging 표시
        GridCommon.createExtPagingNavigator(1, 0, {funcName:'getListAjax'});

        // 그리드 초기화
        AUIGrid.setGridData(myGridID, []);
        AUIGrid.setGridData(detailGridID, []);

        // combo 내역 초기화
        doDefCombo(cdcDs, '', 'sCdc', 'S', '');
        doDefCombo(vendorDs, '', 'sMemAccId', 'S', '');
        doDefCombo(poTypeDs, '', 'sPoTyCd', 'S', '');
        doDefCombo(poStatDs, '', 'sPoStsCd', 'S', '');

        if( js.String.isEmpty($("#sPoDtFrom").val()) ){
            $("#sPoDtFrom").val("${threeMonthBf}");
        }
        if( js.String.isEmpty($("#sPoDtTo").val()) ){
            $("#sPoDtTo").val("${toDay}");
        }

        // 조회버튼
	    $("#btnSearch").click(function(){
	        if(js.String.isEmpty($("#sCdc").val())){
			    Common.alert("Please, check the mandatory value.");
			    return ;
			}

			// 날짜형식 체크
			var sValidDtFrom = $("#sPoDtFrom").val();
			var sValidDtTo = $("#sPoDtTo").val();

			var date_pattern = /^(0[1-9]|[12][0-9]|3[0-1])\/(0[1-9]|1[012])\/(19|20)\d{2}$/;
			if( sValidDtFrom != null && sValidDtFrom != ""
			    && !date_pattern.test(sValidDtFrom)
			) {
			    Common.alert("Please check the date format.");
			    return ;
			}
			if( sValidDtTo != null && sValidDtTo != ""
                && !date_pattern.test(sValidDtTo)
            ) {
                Common.alert("Please check the date format.");
                return ;
            }

			// 메인 그리드 조회
			getListAjax(1);

	    });

        // save 버튼
        $("#btnSave").click(function(){
        	if (!fn_ValidationCheck1()){
        	    return false;
        	}

        	if (!fn_ValidationCheck2()){
                return false;
            }

            // main grid
            var selectRows = AUIGrid.getSelectedItems(myGridID);
            var mainItem = [];
            $.each(selectRows, function(idx, item){
                mainItem.push(item.item);
            });

            var removeList = AUIGrid.getRemovedItems(myGridID);

        	var params = $.extend({"mainData":mainItem}, {"removeData":removeList}, GridCommon.getEditData(detailGridID));

        	Common
	            .confirm(
	                "<spring:message code='sys.common.alert.save'/>",
	                function(){
	                    Common.ajax("POST", "/homecare/po/multiHcPoIssue.do"
	                            , params
	                            , function(result){
	                                Common.alert(result.data  + "<spring:message code='sys.msg.savedCnt'/>");

	                                oldPoNo = -1;
	                                AUIGrid.setGridData(myGridID, []);
	                                AUIGrid.setGridData(detailGridID, []);
	                                $("#btnSearch").click();

	                                //getListAjax(1);
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

        // ISSUE
        $("#btnRequest").click(function(){
            var items = AUIGrid.getSelectedItems(myGridID);
            if(items.length < 1){
            	Common.alert("Please, select a row.");
                return false;
            }

            if(js.String.naNcheck(items[0].item.poStsCode) > 10){
                return false;
            }

        	$("#editTitle").html("Request");
        	$("#editBody").html("Request Reason");
        	$("#btnPopSave").html("Request");
        	$("#popGubun").val("request");
        	$("#issueRsn").val("");
        	$("#editWindow").show();
        });

        // Approval
        $("#btnApproval").click(function(){
            var items = AUIGrid.getSelectedItems(myGridID);
            if(items.length < 1){
                Common.alert("Please, select a row.");
                return false;
            }

            if(Number(items[0].item.poStsCode) != 20){
                return false;
            }

        	$("#editTitle").html("Approve");
        	$("#editBody").html("Approve Reason");
        	$("#btnPopSave").html("Approve");
        	$("#popGubun").val("approve");
        	$("#issueRsn").val("");
        	$("#editWindow").show();
        });

        // Denial
        $("#btnDenial").click(function(){
            var items = AUIGrid.getSelectedItems(myGridID);
            if(items.length < 1){
                Common.alert("Please, select a row.");
                return false;
            }

            if(Number(items[0].item.poStsCode) != 20){
                return false;
            }

        	$("#editTitle").html("Reject");
        	$("#editBody").html("Reject Reason");
        	$("#btnPopSave").html("Reject");
        	$("#popGubun").val("reject");
        	$("#issueRsn").val("");
        	$("#editWindow").show();
        });

        // Print
        $("#btnPrint").click(function(){
        	var items = AUIGrid.getSelectedItems(myGridID);

            if(items.length == 0) {
                Common.alert('No data selected.');
                return false;
            }else if(items.length == 1 ) {
            	if( Number(items[0].item.poStsCode) == 30 || Number(items[0].item.poStsCode) == 90){
	                $("#V_PO_NO").val(items[0].item.poNo);
	                Common.report("printForm");
            	}else{
            		Common.alert('Please check the status.');
            		return false;
            	}
            }else{
                Common.alert('only one [PO No] is possible.');
                return false;
            }
        });

        $("#btnPopSave").click(function(){
            var gubun = $("#popGubun").val();

        	if(gubun == "request"){
                if (!fn_ValidationCheck1(gubun)){
                    return false;
                }

                if (!fn_ValidationCheck2()){
                    return false;
                }

                // main grid
                var selectRows = AUIGrid.getSelectedItems(myGridID);
                var mainItem = [];
                $.each(selectRows, function(idx, item){
                    mainItem.push(item.item);
                });

                var removeList = AUIGrid.getRemovedItems(myGridID);

                var rsnList = [];
                rsnList.push($("#issueRsn").val());

                var params = $.extend({"mainData":mainItem}, {"removeData":removeList}, GridCommon.getEditData(detailGridID), {"rsnList":rsnList});

                Common.ajax("POST", "/homecare/po/multiIssueHcPoIssue.do"
                        , params
                        , function(result){
                            $("#editWindow").hide();
                            Common.alert(result.data  + "<spring:message code='sys.msg.savedCnt'/>");

                            oldPoNo = -1;
                            AUIGrid.setGridData(myGridID, []);
                            AUIGrid.setGridData(detailGridID, []);
                            $("#btnSearch").click();

                            //getListAjax(1);
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

        	}else if(gubun == "approve"){
        		var selectRows = AUIGrid.getSelectedItems(myGridID);

        		var params = { "poNo":selectRows[0].item["poNo"]
        		             , "gubun":"approve"
        		             , "issueRsn":$("#issueRsn").val()};

        		Common.ajax("POST", "/homecare/po/multiApprovalHcPoIssue.do"
                        , params
                        , function(result){
        			        $("#editWindow").hide();
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

        	}else if(gubun == "reject"){
        		var selectRows = AUIGrid.getSelectedItems(myGridID);
        		var params = { "poNo":selectRows[0].item["poNo"]
                , "gubun":"reject"
                , "issueRsn":$("#issueRsn").val()};

			    Common.ajax("POST", "/homecare/po/multiApprovalHcPoIssue.do"
			           , params
			           , function(result){
			    	       $("#editWindow").hide();
			               Common.alert(result.data  + "<spring:message code='sys.msg.savedCnt'/>");
			               getListAjax(1);
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
        });

        $("a[name=btnPopClose]").click(function(){
        	$("#editWindow").hide();
        });

        // main grid button
        $("#btnAdd").click(function(){
        	var addList = AUIGrid.getAddedRowItems(myGridID);
            if(addList.length > 0){
            	// 신규추가는 1건만 가능
            	return false;
            }

			var item = new Object();
			item.poTyCd = "5605";  // PO
			AUIGrid.addRow(myGridID, item, "first");

			// Detail init
			oldPoNo = -1;
			AUIGrid.setGridData(detailGridID, []);
        });
        $("#btnDel").click(function(){
        	var items = AUIGrid.getSelectedItems(myGridID);
        	if(items.length < 1){
                return false;
            }
        	if( js.String.isNotEmpty(items[0].item.poStsCode) && Number(items[0].item.poStsCode) > 10 ){
                return false;
            }

        	// "selectedIndex" : 선택index , index(숫자값)
        	AUIGrid.removeRow(myGridID, "selectedIndex");

            if(js.String.isEmpty(items[0].item.poNo)){
            	// Detail init
                oldPoNo = -1;
                AUIGrid.setGridData(detailGridID, []);
            }
        });

        // sub grid button
        $("#btnSubAdd").click(function(){
            var items = AUIGrid.getSelectedItems(myGridID); // 선택한 row index
            if(items.length < 1){
                return false;
            }

            if( js.String.isNotEmpty(items[0].item.poStsCode) && Number(items[0].item.poStsCode) > 10 ){
                return false;
            }

            if( js.String.isEmpty(items[0].item.cdc)  ){
                Common.alert("Please, check the mandatory value for cdc.");
                return false;
            }

            if( js.String.isEmpty(items[0].item.memAccId)  ){
            	Common.alert("Please, check the mandatory value for Supplier.");
            	return false;
            }

        	$("#svalue").val("");  // item code
        	$("#hMemAccId").val(items[0].item.memAccId);
        	$("#isgubun").val("stocklist");

        	// openDialog ?
        	Common.searchpopupWin("searchForm", "/homecare/po/HcItemSearchPop.do", "stocklist");
        });
        $("#btnSubDel").click(function(){
        	var items = AUIGrid.getSelectedItems(myGridID); // 선택한 row index
            if(items.length < 1){
                return false;
            }

            if( js.String.isNotEmpty(items[0].item.poStsCode) && Number(items[0].item.poStsCode) > 10 ){
                return false;
            }

        	AUIGrid.removeRow(detailGridID, "selectedIndex");
        });

        $("input[type=text]").keypress(function(event) {
            if (event.which == '13'){
                $("#btnSearch").click();
            }
        });

    });


    // 이벤트 정의
    $(function(){

	    // 에디팅 시작 이벤트 바인딩
	    AUIGrid.bind(myGridID, "cellEditBegin", auiCellEditignHandler);

	    // 에디팅 정상 종료 이벤트 바인딩
	    AUIGrid.bind(myGridID, "cellEditEnd", auiCellEditignHandler);

	    // 에디팅 취소 이벤트 바인딩
	    AUIGrid.bind(myGridID, "cellEditCancel", auiCellEditignHandler);

	    // 행 추가 이벤트 바인딩
	    AUIGrid.bind(myGridID, "addRow", auiAddRowHandler);

	    // 행 삭제 이벤트 바인딩
	    AUIGrid.bind(myGridID, "removeRow", auiRemoveRowHandler);

	    // cell change
        //AUIGrid.bind(myGridID, "selectionChange", cellClickEvent);
        AUIGrid.bind(myGridID, "selectionChange", function(event){
        	console.log("# selectItems : " + event.selectedItems);
        	var item = event.selectedItems[0].item;

        	var poNo = item.poNo;
        	if(poNo != oldPoNo){
                AUIGrid.setGridData(detailGridID, []);
                if(js.String.isEmpty(poNo)){
                    oldPoNo = poNo;
                    return false;
                }

                var subParam = {"sPoNo":poNo};
                Common.ajax("GET", "/homecare/po/selectHcPoIssueSubList.do"
                        , subParam
                        , function(result){
                               console.log("data : " + result);
                               AUIGrid.setGridData(detailGridID, result.dataList);
                });

            }
            oldPoNo = poNo;
        });

	    // cellClick event.
        //AUIGrid.bind(myGridID, "cellClick", cellClickEvent);

        // header Click
        AUIGrid.bind(myGridID, "headerClick", function( event ) {
            console.log(event.type + " : " + event.headerText + ", dataField : " + event.dataField + ", index : " + event.columnIndex + ", depth : " + event.item.depth);
            //return false; // 정렬 실행 안함.

            var span = $(".aui-grid-header-panel").find("tbody > tr > td > div")[event.columnIndex];
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

        // 에디팅 시작 이벤트 바인딩
        AUIGrid.bind(detailGridID, "cellEditBegin", auiCellEditingSubHandler);

        // 에디팅 정상 종료 이벤트 바인딩
        AUIGrid.bind(detailGridID, "cellEditEnd", auiCellEditingSubHandler);

        // 에디팅 취소 이벤트 바인딩
        //AUIGrid.bind(detailGridID, "cellEditCancel", auiCellEditingSubHandler);
        // 행 추가 이벤트 바인딩
        //AUIGrid.bind(detailGridID, "addRow", auiAddRowSubHandler);

        // 행 삭제 이벤트 바인딩
        AUIGrid.bind(detailGridID, "removeRow", auiRemoveRowSubHandler);

    });


//--function--//

function auiCellEditignHandler(event){
	if(event.type == "cellEditBegin"){

	    if ( event.dataField == "cdcText"
		  || event.dataField == "poTyCd"
		  || event.dataField == "memAccName"
		  || event.dataField == "cdcDueDt"
		  || event.dataField == "useYn"
		  || event.dataField == "rm"
		 ){
	        // 신규 row만 수정가능.
            //if(!AUIGrid.isAddedById(myGridID, event.item.pid)){
            //    return true;
            //}

	        if(Number(event.item.poStsCode) > 10 ){
	        	return false;
	        }
		}

	    if( !js.String.isEmpty(event.item.poNo) && event.dataField == "cdcText" ){
	        return false;
	    }

	    console.log("에디팅 시작(cellEditBegin) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value);
	}
	else if(event.type == "cellEditEnd")
	{
	    console.log("에디팅 종료(cellEditEnd) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value);

	    if (event.dataField == "cdcText"){
	      AUIGrid.setCellValue(myGridID, event.rowIndex, 0, cdcObj[event.value]==null?"":js.String.strNvl(cdcObj[event.value].codeId));
	      AUIGrid.setCellValue(myGridID, event.rowIndex, 1, cdcObj[event.value]==null?"":js.String.strNvl(cdcObj[event.value].codeCd));
	  	  AUIGrid.setCellValue(myGridID, event.rowIndex, 13, cdcObj[event.value]==null?"":js.String.strNvl(cdcObj[event.value].address));
	  	  AUIGrid.setCellValue(myGridID, event.rowIndex, 14, cdcObj[event.value]==null?"":js.String.strNvl(cdcObj[event.value].telNo));
	      AUIGrid.setCellValue(myGridID, event.rowIndex, "code", cdcObj[event.value]==null?"":js.String.strNvl(cdcObj[event.value].code));
	    }

	    if (event.dataField == "memAccName"){
	  	  AUIGrid.setCellValue(myGridID, event.rowIndex, 9, vendorObj[event.value]==null?"":event.value);

	      var detailData = AUIGrid.getGridData(detailGridID);
	      if(detailData.length > 0){
	    	  Common.alert("When changing supplier, price should be changed.");

	    	  var scodeList = [];
	    	  for(var i=0; i<detailData.length; i++) {
	    		  scodeList.push(js.String.strNvl(detailData[i].stockId)+"");
	    	  }

	    	  var sUrl = "/homecare/po/selectHcItemSearch.do";
	    	  var param = {"sCodeList":scodeList, "memAccId":event.value};
	    	  Common.ajax("POST" , sUrl , param , function(result){
                    var data = result.data;
	    	        for(var i=0; i<detailData.length; i++) {
	    	        	for(var j in data){
	    	        		if(detailData[i].stockId == data[j].itemId){
	    	        			detailData[i].poUprc = js.String.naNcheck(data[j].purchsPrc);
	    	        			var suplyPrc = Number(detailData[i].poUprc) * Number(detailData[i].poQty);
	    	        			var taxRate = js.String.naNcheck(taxObj[detailData[i].taxCd].code) * 0.01;
	    	        			var tax = js.String.naNcheck(suplyPrc*taxRate);
	    	        			var total = (suplyPrc+tax);

	    	        			detailData[i].suplyPrc = suplyPrc;
	    	        			detailData[i].tax = tax;
	    	        			detailData[i].total = total;

	    	        			detailData[i].cur = js.String.strNvl(data[j].cur) == ""?"1150":js.String.strNvl(data[j].cur);
	    	        			break;
	    	        		}
	    	        	}
	                }

	    	        AUIGrid.setGridData(detailGridID, detailData);
	    	        AUIGrid.update(detailGridID);
	    	  });

	      }

	    }
	}
	else if(event.type == "cellEditCancel")
	{
	    console.log("에디팅 취소(cellEditCancel) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value);
	}

}

//행 추가 이벤트 핸들러
function auiAddRowHandler(event)
{
	  gAddRowCnt = gAddRowCnt + event.items.length ;
	    console.log(event.type + " 이벤트\r\n" + "삽입된 행 인덱스 : " + event.rowIndex + "\r\n삽입된 행 개수 : " + event.items.length );
}

//행 삭제 이벤트 핸들러
function auiRemoveRowHandler(event)
{
	  console.log (event.type + " 이벤트 :  " + ", 삭제된 행 개수 : " + event.items.length + ", softRemoveRowMode : " + event.softRemoveRowMode);
}

function cellClickEvent( event ){
	console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
	//var gSelRowIdx = event.rowIndex;

	// 그리드 선택 block을 잡아준다.
	//AUIGrid.setSelectionBlock(myGridID, event.rowIndex, event.rowIndex, 0, event.columnIndex);
	var poNo = AUIGrid.getCellValue(myGridID, event.rowIndex, 3);
	if(poNo != oldPoNo){
	    AUIGrid.setGridData(detailGridID, []);
	    if(js.String.isEmpty(poNo)){
	        oldPoNo = poNo;
	        return false;
	    }

	    var subParam = {"sPoNo":poNo};
	    Common.ajax("GET", "/homecare/po/selectHcPoIssueSubList.do"
	            , subParam
	            , function(result){
	                   console.log("data : " + result);
	                   AUIGrid.setGridData(detailGridID, result.dataList);
	    });

	}
	oldPoNo = poNo;
}

// sub grid handler
function auiCellEditingSubHandler(event){
    if(event.type == "cellEditBegin"){

        if ( event.dataField == "poQty"
          || event.dataField == "poUprc"
          || event.dataField == "suplyPrc"
          || event.dataField == "tax"
          || event.dataField == "taxCd"
          || event.dataField == "cur"
          || event.dataField == "frexAmt"
         ){
            // 신규 row만 수정가능.
            //if(!AUIGrid.isAddedById(myGridID, event.item.pid)){
            //    return true;
            //}

            var selectItem = AUIGrid.getSelectedItems(myGridID);
            if(selectItem.length == 0){
            	return false;
            }
            if( js.String.isNotEmpty(selectItem[0].item.poStsCode) && Number(selectItem[0].item.poStsCode) > 10 ){
                return false;
            }


            <c:if test="${PAGE_AUTH.funcUserDefine2 != 'Y'}">
                if(event.dataField != "poQty"){
                	return false;
                }
            </c:if>
         }

        console.log("에디팅 시작(cellEditBegin) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value);
    }
    else if(event.type == "cellEditEnd")
    {
        console.log("에디팅 종료(cellEditEnd) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value);
        var items = event.item;

        var suplyPrc = 0;
        var taxRate = 0;
        var tax = 0;
        var total = 0;

        // 수량
        if (event.dataField == "poQty"){
          // 공급가격  = 발주단가 * 수량
          suplyPrc = Number(items.poUprc) * Number(event.value);
          // 세율
          taxRate = js.String.naNcheck(taxObj[items.taxCd].code) * 0.01;
          // 세금 = 공급가격 * 세율
          tax = js.String.naNcheck(suplyPrc * taxRate);
          // 합계  = 공급가격+세금
          total = (suplyPrc+tax);

          // 공급가격
          AUIGrid.setCellValue(detailGridID, event.rowIndex, 8, suplyPrc);
          // 세금
          AUIGrid.setCellValue(detailGridID, event.rowIndex, 9, tax);
          // 합계
          AUIGrid.setCellValue(detailGridID, event.rowIndex, 11, total);
        }

        // 발주단가
        if (event.dataField == "poUprc"){
        	// 공급가격
        	suplyPrc = Number(event.value)*Number(items.poQty);
        	// 세율
            taxRate = js.String.naNcheck(taxObj[items.taxCd].code) * 0.01;
            // 세금
            tax = js.String.naNcheck(suplyPrc*taxRate);
            // 합계
            total = (suplyPrc+tax);

            // 공급가격
            AUIGrid.setCellValue(detailGridID, event.rowIndex, 8, suplyPrc);
            // 세금
            AUIGrid.setCellValue(detailGridID, event.rowIndex, 9, tax);
            // 합계
            AUIGrid.setCellValue(detailGridID, event.rowIndex, 11, total);
        }

        // 공급가격
        if (event.dataField == "suplyPrc"){
            // 세율
            taxRate = js.String.naNcheck(taxObj[items.taxCd].code) * 0.01;
            // 세금
            tax = js.String.naNcheck(Number(event.value)*taxRate);
            // 합계
            total = (Number(event.value)+tax);

            // 세금
            AUIGrid.setCellValue(detailGridID, event.rowIndex, 9, tax);
            // 합계
            AUIGrid.setCellValue(detailGridID, event.rowIndex, 11, total);
        }

        // 세금
        if (event.dataField == "tax"){
            // 합계
            total = (Number(items.suplyPrc)+Number(event.value));
            // 합계
            AUIGrid.setCellValue(detailGridID, event.rowIndex, 11, total);
        }

        // 세율
        if (event.dataField == "taxCd"){
            // 세율
            taxRate = js.String.naNcheck(taxObj[event.value].code) * 0.01;
            // 세금
            tax = js.String.naNcheck(Number(items.suplyPrc)*taxRate);
            // 합계
            total = (Number(items.suplyPrc)+tax);

            // 세금
            AUIGrid.setCellValue(detailGridID, event.rowIndex, 9, tax);
            // 합계
            AUIGrid.setCellValue(detailGridID, event.rowIndex, 11, total);
        }

    }
    else if(event.type == "cellEditCancel")
    {
        console.log("에디팅 취소(cellEditCancel) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value);
    }

}

//행 삭제 이벤트 핸들러
function auiRemoveRowSubHandler(event){
    console.log (event.type + " 이벤트 :  " + ", 삭제된 행 개수 : " + event.items.length + ", softRemoveRowMode : " + event.softRemoveRowMode);

    var selectItem = AUIGrid.getSelectedItems(myGridID); // 선택한 row index
    if(selectItem.length < 1){
        return false;
    }

    if( js.String.isNotEmpty(selectItem[0].item.poStsCode) && Number(selectItem[0].item.poStsCode) > 10 ){
        return false;
    }
}


// 메인 그리드 조회
function getListAjax(goPage) {
    var url = "/homecare/po/selectHcPoIssueMainList.do";
    //var param = $("#searchForm").serialize();

    var param = $("#searchForm").serializeObject();

    var sortList = [];
    $.each(mSort, function(idx, row){
        sortList.push(row);
    });

    param = $.extend(param, {"rowCount":25, "goPage":goPage}, {"sort":sortList});
    console.log("param : ", param);

    // 초기화
    oldPoNo = -1;
    AUIGrid.setGridData(myGridID, []);
    Common.ajax("POST" , url , param , function(data){
        // 그리드 페이징 네비게이터 생성
        GridCommon.createExtPagingNavigator(goPage, data.total, {funcName:'getListAjax'});

        AUIGrid.setGridData(myGridID, data.dataList);
        AUIGrid.setGridData(detailGridID, []);

        if(data.total > 0){
            // 행을 선택해줌.
            AUIGrid.setSelectionByIndex(myGridID, 0);
            cellClickEvent({"rowIndex":0, "columnIndex":0});
        }
    });
}

// 조회 팝업 결과
function fn_itempopList(data){
    var rows = AUIGrid.getGridData(detailGridID);

    for(var i=0; i<data.length; i++) {
        var isValid = true;
    	$.each(rows, function(idx, item){
    		if( item.stockId == js.String.strNvl(data[i].item.itemId)
    		 && item.stockCode == js.String.strNvl(data[i].item.itemCode) ){
    			isValid = false;
    		}
    	});
    	if(!isValid){
    		continue;
    	}

    	var item = {};
    	item["stockId"] = js.String.strNvl(data[i].item.itemId);
    	item["stockCode"] = js.String.strNvl(data[i].item.itemCode);
    	item["stockName"] = js.String.strNvl(data[i].item.itemName);
    	item["uom"] = js.String.strNvl(data[i].item.uom);
    	item["poQty"] = 0;
    	item["poUprc"] = Number(js.String.strNvl(data[i].item.purchsPrc));
    	item["suplyPrc"] = 0;
    	item["tax"] = 0;
    	item["taxCd"] = "5614";
    	item["total"] = 0;
    	item["cur"] = js.String.strNvl(data[i].item.cur)==""?"1150":js.String.strNvl(data[i].item.cur);
    	item["frexAmt"] = 0;
        AUIGrid.addRow(detailGridID, item, "first");
	}
}


// save Main validation
function fn_ValidationCheck1(gubun){
	var result = true;

	var selectItem = AUIGrid.getSelectedItems(myGridID);
	if(selectItem.length == 0){
		Common.alert("Please, select the row you want to save.");
        return false;
	}

    if( js.String.isNotEmpty(selectItem[0].item.poStsCode) && Number(selectItem[0].item.poStsCode) > 10 ){
        Common.alert("Please, check the status.");
        return false;
    }

	var addList = AUIGrid.getAddedRowItems(myGridID);
    var udtList = AUIGrid.getEditedRowItems(myGridID);
    var delList = AUIGrid.getRemovedItems(myGridID);

    var subAddList = AUIGrid.getAddedRowItems(detailGridID);
    var subUdtList = AUIGrid.getEditedRowItems(detailGridID);
    var subDelList = AUIGrid.getRemovedItems(detailGridID);

    if (typeof(gubun) == "undefined" && addList.length == 0 && udtList.length == 0 && delList.length == 0
    		&& subAddList.length == 0 && subUdtList.length == 0 && subDelList.length == 0){
        Common.alert("No Change");
        return false;
    }

    // 선택한 row가 삭제한 행이면 요청 불가.
    if(typeof(gubun) != "undefined" && delList.length > 0){
    	var isDel = false;
    	$.each(delList, function(idx, row){
            if(selectItem[0].item.poNo == row.poNo){
                isDel = true;
            }
        });
    	if(isDel){
    		Common.alert("Please check the status. <br /> Please search again.");
    		return false;
    	}
    }

    // 선택한 값이 삭제행일 경우. : 체크 안함.
    if(delList.length > 0){
        var isSeleteDeleteRow = false;
        $.each(delList, function(idx, row){
            if(selectItem[0].item.poNo == row.poNo){
                isSeleteDeleteRow = true;
            }
        });
        if(!isSeleteDeleteRow){
        	result = fn_validChk(selectItem);
        }
    }else{
     	result = fn_validChk(selectItem);
    }

	return result;
}


function fn_validChk(selectItem){
	var result = true;
    for (var i = 0; i < selectItem.length; i++){
        var cdcDueDt = selectItem[i].item.cdcDueDt;
        var cdc = selectItem[i].item.cdc;
        var cdcText = selectItem[i].item.cdcText;
        var memAccId = selectItem[i].item.memAccId;

        if (js.String.isEmpty(cdcDueDt) || !fn_isDateValidate(cdcDueDt) ){
            result = false;
            Common.alert("Date format is invalid.");
            break;
        }
        if (js.String.isEmpty(cdc)){
            result = false;
            Common.alert("Please select a CDC.");
            break;
        }
        if (js.String.isEmpty(cdcText)){
            result = false;
            Common.alert("Please input the CDC Name.");
            break;
        }
        if (js.String.isEmpty(memAccId)){
            result = false;
            Common.alert("Please select a Supplier ID.");
            break;
        }
    }
	return result;
}

function fn_ValidationCheck2(){
    var result = true;

    var dataItem = AUIGrid.getGridData(detailGridID);

    var addList = AUIGrid.getAddedRowItems(detailGridID);
    var updateList = AUIGrid.getEditedRowItems(detailGridID);
    //var delList = AUIGrid.getRemovedItems(detailGridID);
    var item = [], uItem = [];
    if(addList.length > 0){
    	//item = item.concat(addList);
    	item = JSON.parse(JSON.stringify( addList ));
    }
    if(updateList.length > 0){
    	//item = item.concat(updateList);
    	uItem = JSON.parse(JSON.stringify( updateList ));
    }

    item = item.concat(uItem);

    if(dataItem.length == 0){
    	Common.alert("Please, Input item information.");
    	return false;
    }

    for (var i = 0; i < item.length; i++){
        var poQty = item[i].poQty;
        var poUprc = item[i].poUprc;
        var suplyPrc = item[i].suplyPrc;
        var tax = item[i].tax;
        var total = item[i].total;
        var cur = item[i].cur;

        if (js.String.isEmpty(poQty) || js.String.naNcheck(poQty) < 1){
            result = false;
            Common.alert("Please input the PO QTY");
            break;
        }
        if (js.String.isEmpty(poUprc)){
            result = false;
            Common.alert("Please input the PO Price.");
            break;
        }
        if (js.String.isEmpty(suplyPrc)){
            result = false;
            Common.alert("Please select a Supply Price.");
            break;
        }
        if (js.String.isEmpty(tax)){
            result = false;
            Common.alert("Please select a Tax Text.");
            break;
        }
        if (js.String.isEmpty(total)){
            result = false;
            Common.alert("Please select a Total.");
            break;
        }
        if (js.String.isEmpty(cur)){
            result = false;
            Common.alert("Please select a Currency.");
            break;
        }

    }
    return result;
}


/*  모달  */
function f_showModal(){
    $.blockUI.defaults.css = {textAlign:'center'}
    $('div.SalesWorkDiv').block({
            message:"<img src='/resources/images/common/CowayLeftLogo.png' alt='Coway Logo' style='max-height: 46px;width:160px' /><div class='preloader'><i id='iloader'>.</i><i id='iloader'>.</i><i id='iloader'>.</i></div>",
            centerY: false,
            centerX: true,
            css: { top: '300px', border: 'none'}
    });
}
function hideModal(){
    $('div.SalesWorkDiv').unblock();
}

/**
* yyyy/MM/dd 날짜 형식을 체크함.
*/
function fn_isDateValidate(sValidDt){
	// 날짜형식 체크
    //var date_pattern = /^(0[1-9]|[12][0-9]|3[0-1])\/(0[1-9]|1[012])\/(19|20)\d{2}$/;    // dd/MM/yyyy
    var date_pattern = /^(19|20)\d{2}\/(0[1-9]|1[012])\/(0[1-9]|[12][0-9]|3[0-1])$/;      // yyyy/MM/dd
    if( sValidDt != null && sValidDt != ""
        && !date_pattern.test(sValidDt)
    ) {
        return false;
    }
    return true;
}

</script>
<div id="SalesWorkDiv" class="SalesWorkDiv" style="width: 100%; height: 960px; position: static; zoom: 1;">
<section id="content"><!-- content start -->
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif"
                alt="Home" /></li>
        <li>Homecare</li>
        <li>SCM</li>
        <li>POManager</li>
    </ul>

    <aside class="title_line"><!-- title_line start -->
        <p class="fav"><a href="#none" class="click_add_on">My menu</a></p>
        <h2>PO Issue(HC)</h2>

        <ul class="right_btns">
        <c:if test="${PAGE_AUTH.funcView == 'Y'}">
            <li><p class="btn_blue"><a id="btnSearch"><span class="search"></span>Search</a></p></li>
        </c:if>
        <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
            <li><p class="btn_blue"><a id="btnSave">Save</a></p></li>
            <li><p class="btn_blue"><a id="btnRequest">Request</a></p></li>
        </c:if>
        <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
            <li><p class="btn_blue"><a id="btnApproval">Approve</a></p></li>
            <li><p class="btn_blue"><a id="btnDenial">Reject</a></p></li>
        </c:if>
        <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
            <li><p class="btn_blue"><a id="btnPrint">Print</a></p></li>
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
                    <th scope="row">PO Date</th>
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
                    <th scope="row">Supplier</th>
                    <td>
                        <select id="sMemAccId" name="sMemAccId" title="" placeholder="" class="w100p" >
                    </td>
                </tr>

                <tr>
                    <th scope="row">PO Type</th>
                    <td >
                        <select id="sPoTyCd" name="sPoTyCd" placeholder="" class="w100p" >
                    </td>
                    <th scope="row">PO Status</th>
                    <td >
                        <select id="sPoStsCd" name="sPoStsCd" placeholder="" class="w100p" >
                    </td>
                    <th scope="row">PO No</th>
                    <td >
                        <input type="text" id="sPoNo" name="sPoNo" placeholder="" class="w100p" >
                    </td>
                </tr>
            </tbody>
        </table><!-- table end -->

        <input type="hidden" id="svalue" name="svalue"/>
        <input type="hidden" id="hMemAccId" name="hMemAccId"/>
        <input type="hidden" id="isgubun"   name="isgubun"  />
    </form>
    </section><!-- search_table end -->

    <!-- data body start -->
  <section class="search_result"><!-- search_result start -->
	<aside class="title_line"><!-- title_line start -->
	  <h3>CDC Information</h3>
	  <ul class="right_btns">
	  <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
	    <li><p class="btn_grid"><a id="btnAdd">Add</a></p></li>
	    <li><p class="btn_grid"><a id="btnDel">Del</a></p></li>
	  </c:if>
	  </ul>
	</aside><!-- title_line end -->
	<!-- grid_wrap start -->
	<article class="grid_wrap">
	   <!-- 그리드 영역1 -->
	   <div id="mainGrid" style="height:320px;"></div>

	   <!-- 그리드 페이징 네비게이터 -->
       <div id="grid_paging" class="aui-grid-paging-panel my-grid-paging-panel"></div>
	</article>
	<!-- grid_wrap end -->

	<aside class="title_line"><!-- title_line start -->
	    <h3>Item Information</h3>
	    <ul class="right_btns">
	    <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
	        <li><p class="btn_grid"><a id="btnSubAdd">Add</a></p></li>
	        <li><p class="btn_grid"><a id="btnSubDel">Del</a></p></li>
	    </c:if>
	    </ul>
	</aside><!-- title_line end -->
	<article class="grid_wrap" ><!-- grid_wrap start -->
	  <!--  그리드 영역2  -->
	  <div id="subGrid" class="autoGridHeight"></div>
	</article><!-- grid_wrap end -->
  </section><!-- data body end -->


  <!-- Issue popup -->
  <div class="popup_wrap" id="editWindow" style="display:none"><!-- popup_wrap start -->
	<header class="pop_header"><!-- pop_header start -->
	   <h1 id="editTitle">Approve</h1>
	   <ul class="right_opt">
		    <li><p class="btn_blue2"><a name="btnPopClose">CLOSE</a></p></li>
	   </ul>
	</header><!-- pop_header end -->
	<section class="pop_body"><!-- pop_body start -->
	<form id="insForm" name="insForm" method="POST">
	    <input type="hidden" id="popGubun">
		<table class="type1"><!-- table start -->
		  <caption>remark table</caption>
		  <colgroup>
		    <col style="width:120px" />
		    <col style="width:*" />
		  </colgroup>
		  <tbody>
		      <tr>
		          <th scope="row" id="editBody">Issue Reason</th>
		          <td >
		              <textarea rows="5" cols="20" maxlength="200" id="issueRsn" name="issueRsn" placeholder="Remark"></textarea>
		          </td>
		      </tr>
		  </tbody>
        </table><!-- table end -->

		<ul class="center_btns">
		    <li><p class="btn_blue2 big"><a id="btnPopSave">SAVE</a></p></li>
		    <li><p class="btn_blue2 big"><a name="btnPopClose">CLOSE</a></p></li>
		</ul>
	</form>
	</section>
  </div>
  <!-- Issue popup end -->

  <form id="printForm" name="printForm">
    <input type="hidden" id="viewType" name="viewType" value="PDF" />
    <input type="hidden" id="V_PO_NO" name="V_PO_NO" value="" />
    <input type="hidden" id="reportFileName" name="reportFileName" value="/homecare/hcPoIssue_report.rpt" /><br />
  </form>

</section><!-- content end -->
</div>