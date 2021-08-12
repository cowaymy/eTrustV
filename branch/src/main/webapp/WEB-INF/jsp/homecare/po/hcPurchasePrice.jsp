<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/homecare-js-1.0.js"></script>

<style type="text/css">

/* 커스텀 칼럼 콤보박스 스타일 정의 */
.aui-grid-drop-list-ul {
    text-align:left;
}

/* aui-grid-paging-number 클래스 재정의 */
.aui-grid-paging-panel .aui-grid-paging-number {
    border-radius : 4px;
}
</style>

<script type="text/javaScript">

var oldSeqNo = -1;

var curComboData = [];
<c:forEach var="obj" items="${curList}">
  curComboData.push({codeId:"${obj.codeId}", codeName:"${obj.codeName}", code:"${obj.code}"});
</c:forEach>

var uomComboData = [];
<c:forEach var="obj" items="${uomList}">
  uomComboData.push({codeId:"${obj.codeId}", codeName:"${obj.codeName}", code:"${obj.code}"});
</c:forEach>

var vendorDs = [];
<c:forEach var="obj" items="${vendorList}">
  vendorDs.push({codeId:"${obj.codeId}", codeName:"${obj.codeNames}"});
</c:forEach>

var cmbCategoryDs = [{codeId:"5706", codeName:"Mattress"}, {codeId:"5707", codeName:"Frame"}];

    //AUIGrid 생성 후 반환 ID
    var myGridID, detailGridID;

    //var comboData = [{"codeId": "1","codeName": "Active"},{"codeId": "7","codeName": "Obsolete"},{"codeId": "8","codeName": "Inactive"}];

    // AUIGrid main 칼럼 설정
    var columnLayout = [{dataField: "rnum", visible:false},
            {dataField: "priceSeqNo", headerText :"Price Seq", width:120, editable:false},
            {dataField: "memAccId",headerText :"Supplier Code", width:120, editable:false},
            {dataField: "memAccName",headerText :"Supplier Name", width:350, style:"aui-grid-user-custom-left", editable:false },
            {dataField: "stkId",headerText :"Material Id",width:120, editable:false, visible:false},
            {dataField: "stkCode",headerText :"Material Code",width:140, editable:false},
            {dataField: "stkDesc",headerText :"Material Name",width:300, style:"aui-grid-user-custom-left", editable:false},
            {dataField: "uom", headerText:"UOM", width:120, editable:false
                ,labelFunction : function(rowIndex, columnIndex, value, headerText, item ) {
                    //var retStr = value;
                    var retStr = "";
                    for(var i=0, len=uomComboData.length; i<len; i++) {
                        if(uomComboData[i]["codeId"] == value) {
                            retStr = uomComboData[i]["codeName"];
                            break;
                        }
                    }
                    return retStr;
                }
                , editRenderer : {
                         type : "DropDownListRenderer",
                         showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                         listFunction : function(rowIndex, columnIndex, item, dataField) {
                             return uomComboData;
                         },
                         keyField : "codeId",        // key 에 해당되는 필드명
                         valueField : "codeName"    // value 에 해당되는 필드명
                 }
            },
            {dataField: "validStartDt", headerText :"Valid From", width:120, headerStyle:"aui-grid-header-input-icon aui-grid-header-input-essen"
              , dataType:"date"
              , formatString:"dd-mm-yyyy"     // 실제 데이터 형식을 어떻게 표시할지 지정
              , editRenderer : {
                    type : "CalendarRenderer"
                    , onlyMonthMode:false
                    , showEditorBtnOver:true
                    //, defaultFormat : "dd-mm-yyyy" // 달력 선택 시 데이터에 적용되는 날짜 형식
                    , onlyCalendar : true // 사용자 입력 불가, 즉 달력으로만 날짜입력 (기본값 : true)
                    , maxlength : 10 // 10자리 이하만 입력 가능
                    , openDirectly : true  // 에디팅 진입 시 바로 달력 열기
                    , onlyNumeric : false // 숫자
                    , validator : function(oldValue, newValue, rowItem) { // 에디팅 유효성 검사
                        var isValid = true;
                        var pattern = /^(0[1-9]|[12][0-9]|3[0-1])-(0[1-9]|1[012])-(19|20)\d{2}$/;
                        if(js.String.isNotEmpty(newValue) && !pattern.test(newValue)) {
                        	isValid = false;
                        }
                         //리턴값은 Object 이며 validate 의 값이 true 라면 패스, false 라면 message 를 띄움
                        return { "validate":isValid, "message":"10자리, 01-02-2019 형식으로 입력해주세요." };
                    }
              }
            },
            {dataField:"validEndDt", headerText :"Valid To", width:120, headerStyle:"aui-grid-header-input-icon aui-grid-header-input-essen"
                , dataType:"date"
                , formatString:"dd-mm-yyyy"     // 실제 데이터 형식을 어떻게 표시할지 지정
                //, dateInputFormat:"dd-mm-yyyy"  // 실제 데이터의 형식 지정
                , editRenderer : {
                    type : "CalendarRenderer"
                    , showEditorBtnOver:true
                    //, defaultFormat:"dd-mm-yyyy" // 달력 선택 시 데이터에 적용되는 날짜 형식
                    , onlyCalendar:true // 사용자 입력 불가, 즉 달력으로만 날짜입력 (기본값 : true)
                    , maxlength:10 // 10자리 이하만 입력 가능
                    //, onlyNumeric : true, // 숫자
                    , validator:function(oldValue, newValue, rowItem) { // 에디팅 유효성 검사
                        var isValid = true;
                        var pattern = /^(0[1-9]|[12][0-9]|3[0-1])-(0[1-9]|1[012])-(19|20)\d{2}$/;
                        if(js.String.isNotEmpty(newValue) && !pattern.test(newValue)) {
                            isValid = false;
                        }
                        // 리턴값은 Object 이며 validate 의 값이 true 라면 패스, false 라면 message 를 띄움
                        return { "validate":isValid, "message":"10자리, 01-02-2019 형식으로 입력해주세요." };
                    }
                }
            },
            {dataField:"purchsPrc", headerText:"Price", width:120, headerStyle:"aui-grid-header-input-icon aui-grid-header-input-essen"
            	, style:"aui-grid-user-custom-right"
                , dataType:"numeric"
                , formatString:"#,##0.00"
                , editRenderer:{
                          type:"InputEditRenderer",
                          //showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                          onlyNumeric:true,   // 0~9만 입력가능
                          allowPoint:true,    // 소수점( . ) 도 허용할지 여부
                          allowNegative:true, // 마이너스 부호(-) 허용 여부
                          textAlign:"right",  // 오른쪽 정렬로 입력되도록 설정
                          autoThousandSeparator:true // 천단위 구분자 삽입 여부
                  }

            },
            {dataField: "cur", headerText:"CUR", width:120
                ,labelFunction : function(rowIndex, columnIndex, value, headerText, item ) {
                    var retStr = value;
                    for(var i=0, len=curComboData.length; i<len; i++) {
                        if(curComboData[i]["codeId"] == value) {
                            retStr = curComboData[i]["codeName"];
                            break;
                        }
                    }
                    return retStr;
                }
                ,editable:false
                ,editRenderer : {
                    type : "DropDownListRenderer",
                    showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                    list : curComboData,
                    keyField : "codeId",        // key 에 해당되는 필드명
                    valueField : "codeName"    // value 에 해당되는 필드명
                }
            },
            {dataField:"crtDt", headerText :"create date", width:120, editable:false
                , dataType:"date"
                , formatString:"dd-mm-yyyy"     // 실제 데이터 형식을 어떻게 표시할지 지정
                , dateInputFormat:"dd-mm-yyyy"  // 실제 데이터의 형식 지정
            },
            {dataField: "crtUserId", headerText :"Creator", width:120, editable:false}
    ];

    // main 그리드 속성 설정
    var grid_options = {
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
      rowIdField : "rnum",
      enableSorting : false,
      showRowCheckColumn : false,    // row checkbox
      enableRestore: true
    };

    // sub 칼럼 설정
	var subColumnLayout = [{dataField: "priceSeqNo", headerText :"Price Seq", width:120},
	                    {dataField: "memAccId",headerText :"Supplier Code", width:120},
	                    {dataField: "memAccName",headerText :"Supplier Name", width:350, style:"aui-grid-user-custom-left" },
	                    {dataField: "stockId",headerText :"Material Id",width:120, visible:false},
	                    {dataField: "stockCode",headerText :"Material Code",width:140},
	                    {dataField: "stkDesc",headerText :"Material Name",width:300, style:"aui-grid-user-custom-left"},
	                    {dataField: "validStartDt", headerText :"Valid From", width:120
	                      , dataType:"date"
	                      , formatString:"dd-mm-yyyy"     // 실제 데이터 형식을 어떻게 표시할지 지정
	                      , dateInputFormat:"dd-mm-yyyy"  // 실제 데이터의 형식 지정
	                    },
	                    {dataField:"validEndDt", headerText :"Valid To", width:120
	                        , dataType:"date"
	                        , formatString:"dd-mm-yyyy"     // 실제 데이터 형식을 어떻게 표시할지 지정
	                        , dateInputFormat:"dd-mm-yyyy"  // 실제 데이터의 형식 지정
	                    },
	                    {dataField: "cur", headerText:"CUR", width:120
	                    	//, style:"aui-grid-user-custom-left"
	                        ,labelFunction : function(rowIndex, columnIndex, value, headerText, item ) {
	                            var retStr = value;
	                            for(var i=0, len=curComboData.length; i<len; i++) {
	                                if(curComboData[i]["codeId"] == value) {
	                                    retStr = curComboData[i]["codeName"];
	                                    break;
	                                }
	                            }
	                            return retStr;
	                        }
	                    },
	                    {dataField:"purchsPrc", headerText:"Price", width:120
	                        , style:"aui-grid-user-custom-right"
	                        , dataType:"numeric"
	                        , formatString:"#,##0.00"
	                    },
	                    {dataField: "uom", headerText:"UOM", width:120
	                        ,labelFunction : function(rowIndex, columnIndex, value, headerText, item ) {
	                            //var retStr = value;
	                            var retStr = "";
	                            for(var i=0, len=uomComboData.length; i<len; i++) {
	                                if(uomComboData[i]["codeId"] == value) {
	                                    retStr = uomComboData[i]["codeName"];
	                                    break;
	                                }
	                            }
	                            return retStr;
	                        }
	                    },
	                    {dataField:"crtDt", headerText :"create date", width:120
	                        , dataType:"date"
	                        , formatString:"dd-mm-yyyy"     // 실제 데이터 형식을 어떻게 표시할지 지정
	                        , dateInputFormat:"dd-mm-yyyy"  // 실제 데이터의 형식 지정
	                    },
	                    {dataField: "crtUserId", headerText :"Creator", width:120}
	            ];

    // sub 그리드 속성 설정
    var subGrid_options = {
      usePaging : true,           // 페이지 설정1
      pageRowCount : 30,          // 페이지 설정2
      fixedColumnCount : 0,        // 틀고정(index)
      editable : false,             // 편집 가능 여부 (기본값 : false)
      //enterKeyColumnBase : false,   // 엔터키가 다음 행이 아닌 다음 칼럼으로 이동할지 여부 (기본값 : false)
      //selectionMode : "singleCell", // 셀 선택모드 (기본값: singleCell): (singleCell, singleRow), (multipleCells, multipleRows)
      //useContextMenu : false,       // 컨텍스트 메뉴 사용 여부 (기본값 : false)
      showRowNumColumn : true,     // 그리드 넘버링
      //enableFilter : true,         // 필터 사용 여부 (기본값 : false)
      useGroupingPanel : false,    // 그룹핑 패널 사용
      //displayTreeOpen : false,     // 그룹핑 또는 트리로 만들었을 때 펼쳐지게 할지 여부 (기본값 : false)
      showStateColumn : false,      // 상태 칼럼 사용
      noDataMessage : "No Data to display",
      //groupingMessage : "여기에 칼럼을 드래그하면 그룹핑이 됩니다.",
      //rowIdField : "priceSeqNo",
      enableSorting : true,
      showRowCheckColumn : false,    // row checkbox
      enableRestore: true
    };

    $(document).ready(function(){

        // masterGrid 그리드를 생성합니다.
        myGridID = GridCommon.createAUIGrid("mainGrid", columnLayout, "stkId", grid_options);
        detailGridID = GridCommon.createAUIGrid("subGrid", subColumnLayout,"", subGrid_options);

        // 그리드 초기화
        AUIGrid.setGridData(myGridID, []);
        AUIGrid.setGridData(detailGridID, []);

        // main 그리드 페이징 네비게이터 생성
        createPagingNavigator(1);

        // combo 내역 초기화
        doDefCombo(vendorDs, ' ' ,'sMemAccId', 'S', 'f_multiCombo');
        doDefCombo(cmbCategoryDs, '', 'sCategory', 'M', 'f_multiCombo');
        doGetCombo('/common/selectCodeList.do', '15', '','sType', 'M' , 'f_multiCombo');

        $("#sValidDt").val("${toDay}");

        // 조회 팝업 클릭
        $("#search_material_btn").click(function(){
            $("#svalue").val($("#sStkId").val());
            $("#isgubun").val("stock");
            Common.searchpopupWin("searchForm", "/homecare/po/HcItemSearchPop.do","stock");
        });

        //$("#sStkCd").keypress(function(event) {
        //    if (event.which == '13') {
        //        $("#svalue").val($("#sStkId").val());
        //        $("#sUrl").val("/logistics/material/materialcdsearch.do");
        //        Common.searchpopupWin("searchForm", "/common/searchPopList.do","stock");
        //    }
        //});

        // save 버튼
        $("#btnSave").click(function(){
        	if (!fn_ValidationCheck()){
        	    return false;
        	}

        	Common
	            .confirm(
	                "<spring:message code='sys.common.alert.save'/>",
	                function(){
	                    Common.ajax("POST", "/homecare/po/multiHcPurchasePrice.do"
	                            , GridCommon.getEditData(myGridID)
	                            , function(result){
	                                Common.alert(result.data  + "<spring:message code='sys.msg.savedCnt'/>");
	                                getListAjax(rowCount, 1);
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


        // ---------------------------------------- //
        // 달력 재정의.
        var holidays = {//휴일 세팅 하기
       	    /*"0809":{type:0, title:"신정", year:"2017"}*/
       	};
        var isLoadHoliday = false;
        var pickerOpts = {//일반년월일달력 세팅
       	    changeMonth: true,
       	    changeYear: true,
       	    dateFormat: "dd-mm-yy",
       	    beforeShowDay: function (day) {

       	        if (!isLoadHoliday) {
       	            isLoadHoliday = true;
       	            try{
       	                // get holiday list
       	                Common.ajaxSync("GET", "/common/getPublicHolidayList.do", {}, function (result) {
       	                    for (var idx = 0; idx < result.length; idx++) {
       	                        holidays[result[idx].mmdd] = {
       	                            type: 0,
       	                            title: result[idx].holidayDesc,
       	                            year: result[idx].yyyy
       	                        };
       	                    }
       	                });
       	            }catch(e){
       	                Common.removeLoader();
       	                console.log("common_pub.js => getHolidays fail : " + e);
       	            }
       	        }

       	        var result;
       	        // 포맷에 대해선 다음 참조(http://docs.jquery.com/UI/Datepicker/formatDate)
       	        var holiday = holidays[$.datepicker.formatDate("mmdd", day)];
       	        var thisYear = $.datepicker.formatDate("yy", day);

       	        // exist holiday?
       	        if (holiday) {
       	            if (thisYear == holiday.year || holiday.year == "") {
       	                result = [true, "date-holiday", holiday.title];
       	            }
       	        }

       	        if (!result) {
       	            switch (day.getDay()) {
       	                case 0: // is sunday?
       	                    result = [true, "date-sunday"];
       	                    break;
       	                case 6: // is saturday?
       	                    result = [true, "date-saturday"];
       	                    break;
       	                default:
       	                    result = [true, ""];
       	                    break;
       	            }
       	        }

       	        return result;
       	    }
       	};
        $(document).on(//일반년월일달력 실행
       	    "focus", ".j_date0", function(){
       	    $(this).datepicker(pickerOpts);
       	});
        // ---------------------------------------- //

    });


    $(function(){

      $("#search").click(function(){
    	  if(js.String.isEmpty($("#sMemAccId").val())){
    		  Common.alert("Please check the mandatory value.");
              return ;
    	  }

    	  // 날짜형식 체크
    	  var sValidDt = $("#sValidDt").val();
    	  var date_pattern = /^(0[1-9]|[12][0-9]|3[0-1])-(0[1-9]|1[012])-(19|20)\d{2}$/;
    	  if( sValidDt != null && sValidDt != ""
    		  && !date_pattern.test(sValidDt)
    	  ) {
    		  Common.alert("Please check the date format.");
    		  return ;
    	  }

    	  // 그리드 조회
    	  getListAjax(rowCount, 1);

        });

        /*
        // cellClick event.
		AUIGrid.bind(myGridID, "cellClick", function( event ) {
			var items = event.selectedItems;
			console.log("# cellClick");
		});

		AUIGrid.bind(myGridID, "selectionChange", function( event ) {
            var items = event.selectedItems;
            console.log("# selectionChange");
        });
		*/

        // cellClick event.
        AUIGrid.bind(myGridID, "cellClick", cellClickEvent);

		// header Click
        AUIGrid.bind(myGridID, "headerClick", function( event ) {
            console.log(event.type + " : " + event.headerText + ", dataField : " + event.dataField + ", index : " + event.columnIndex + ", depth : " + event.item.depth);
            //return false; // 정렬 실행 안함.

            var span = $(".aui-grid-header-panel").find("tbody > tr > td > div")[event.columnIndex];
            if(sort.hasOwnProperty(event.dataField)){
            	if(sort[event.dataField].dir == "asc"){
            	    sort[event.dataField] = {"field":event.dataField, "dir":"desc" };
            	    $(span).removeClass("aui-grid-sorting-ascending");
            	    $(span).addClass("aui-grid-sorting-descending");
            	}else{
            		delete sort[event.dataField];
            		$(span).removeClass("aui-grid-sorting-descending");
            	}
            }else{
            	sort[event.dataField] = {"field":event.dataField, "dir":"asc"};
            	$(span).addClass("aui-grid-sorting-ascending");
            }

            getListAjax(rowCount, 1);
       });

    });

    // ## 페이징 처리 ## //
    //페이징 변수 선언
    var totalRowCount = 0;     // 전체 데이터 건수
    var rowCount = 30;         // 한페이지에서 보여줄 행 수
    var pageButtonCount = 10;  // 페이지 네비게이션에서 보여줄 페이지의 수
    var currentPage = 1;       // 현재 페이지
    var totalPage = 0;         // 전체 페이지 계산

    var sort = {};

    // 전체 데이터 건수 입력 및 Total Page 갱신
    function setTotalRowCount(totalCnt){
    	totalRowCount = totalCnt;
    	totalPage = Math.ceil(totalRowCount / rowCount);    // 전체 페이지 계산
    }

    // 페이징 네비게이터를 동적 생성합니다.
    function createPagingNavigator(goPage) {
        var retStr = "";
        var prevPage = parseInt((goPage - 1)/pageButtonCount) * pageButtonCount;
        var nextPage = ((parseInt((goPage - 1)/pageButtonCount)) * pageButtonCount) + pageButtonCount + 1;

        prevPage = Math.max(0, prevPage);
        nextPage = Math.min(nextPage, totalPage);

        // 처음
        retStr += "<a href='javascript:moveToPage(1)'><span class='aui-grid-paging-number aui-grid-paging-first'>first</span></a>";

        // 이전
        retStr += "<a href='javascript:moveToPage(" + Math.max(1, prevPage) + ")'><span class='aui-grid-paging-number aui-grid-paging-prev'>prev</span></a>";

        for (var i=(prevPage+1), len=(pageButtonCount+prevPage); i<=len; i++) {
            if (goPage == i) {
                retStr += "<span class='aui-grid-paging-number aui-grid-paging-number-selected'>" + i + "</span>";
            } else {
                retStr += "<a href='javascript:moveToPage(" + i + ")'><span class='aui-grid-paging-number'>";
                retStr += i;
                retStr += "</span></a>";
            }

            if (i >= totalPage) {
                break;
            }
        }

        // 다음
        retStr += "<a href='javascript:moveToPage(" + nextPage + ")'><span class='aui-grid-paging-number aui-grid-paging-next'>next</span></a>";

        // 마지막
        retStr += "<a href='javascript:moveToPage(" + totalPage + ")'><span class='aui-grid-paging-number aui-grid-paging-last'>last</span></a>";

        //  페이지 정보 표시
        var firstIndex = Number( (rowCount * currentPage) - rowCount + 1 );
        var lastIndex  = Number( rowCount * goPage ) > totalRowCount ? totalRowCount : rowCount * goPage;
        var pageInfo = "<span class='aui-grid-paging-info-text' style='position: absolute;'> "+firstIndex+" ~ "+lastIndex+" of "+totalRowCount+" rows </span>";
        if(totalRowCount <= 0){
        	pageInfo = "";
        }

        $("#grid_paging").html(pageInfo + retStr);
    }

    function moveToPage(goPage) {
        // 페이징 네비게이터 업데이트
        createPagingNavigator(goPage);

        // 현재 페이지 보관
        currentPage = goPage;

        // 메인그리드 조회
        getListAjax(rowCount, goPage);
    }

    // serializeObject : 선언
    $.fn.serializeObject = function() {
    	  var result = {}
    	  var extend = function(i, element) {
    	    var node = result[element.name]
    	    if ("undefined" !== typeof node && node !== null) {
    	      if ($.isArray(node)) {
    	        node.push(element.value)
    	      } else {
    	        result[element.name] = [node, element.value]
    	      }
    	    } else {
    	      result[element.name] = element.value
    	    }
    	  }

    	  $.each(this.serializeArray(), extend)
    	  return result
    }


    // 메인 그리드 조회
    function getListAjax(rowCount, goPage) {
        var url = "/homecare/po/selectHcPurchasePriceList.do";
        /*
        var param = $("#searchForm").serialize();
        param += "&rowCount="+rowCount;
        param += "&goPage="+goPage;
        console.log("param : ", param);
        */
        var param = $("#searchForm").serializeObject();

        if(param.sCategory != null && !$.isArray(param.sCategory) ){
        	var sCategory = [];
        	sCategory.push(param.sCategory);
        	param.sCategory = sCategory;
        }
        if(param.sType != null && !$.isArray(param.sType) ){
            var sType = [];
            sType.push(param.sType);
            param.sType = sType;
        }

        var sortList = [];
        $.each(sort, function(idx, row){
        	sortList.push(row);
        });

        param = $.extend(param, {"rowCount":rowCount, "goPage":goPage}, {"sort":sortList});
        console.log("param : ", param);
        //console.log("$param : ", JSON.stringify(param));

        // 초기화
        oldSeqNo = -1;
        setTotalRowCount(0);
        AUIGrid.setGridData(myGridID, []);

        Common.ajax("POST" , url , param, function(data){
            var list= data.dataList

            setTotalRowCount(data.total);

            // 그리드 페이징 네비게이터 생성
            createPagingNavigator(goPage);

            AUIGrid.setGridData(myGridID, list);
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
        console.log(data);
        $("#sStkCd").val(data[0].item.itemCode);
        $("#sStkNm").val(data[0].item.itemName);
    }


    // 멀티 콤보 설정
    function f_multiCombo() {
        $(function() {
            $('#sCategory').change(function() {
            }).multipleSelect({
                selectAll : true,
                width: '100%'
            });
            $('#sType').change(function() {
            }).multipleSelect({
                selectAll : true,
                width : '80%'
            });
        });
    }

    // validation
    function fn_ValidationCheck(){
    	var result = true;

    	var addList = AUIGrid.getAddedRowItems(myGridID);
        var udtList = AUIGrid.getEditedRowItems(myGridID);
        var delList = AUIGrid.getRemovedItems(myGridID);

        if (addList.length == 0  && udtList.length == 0 && delList.length == 0){
            Common.alert("No Change");
            return false;
	    }

        for (var i = 0; i < udtList.length; i++){
            var validStartDt = udtList[i].validStartDt;
            var validEndDt = udtList[i].validEndDt;
            var cur = udtList[i].cur;
            var purchsPrc = udtList[i].purchsPrc;
            var uom = udtList[i].uom;

            if (js.String.isEmpty(validStartDt) || !fn_isDateValidate(validStartDt) ){
                result = false;
                // {0} is required.
                //Common.alert("<spring:message code='sys.msg.necessary' arguments='Code Master Name' htmlEscape='false'/>");
                Common.alert("Date format is invalid.");
                break;
            }

            if (js.String.isEmpty(validEndDt) || !fn_isDateValidate(validEndDt) ){
                result = false;
                // {0} is required.
                //Common.alert("<spring:message code='sys.msg.necessary' arguments='Code Master Name' htmlEscape='false'/>");
                Common.alert("Date format is invalid.");
                break;
            }

            var arrStDt = validStartDt.split('/');
            var arrEnDt = validEndDt.split('/');
            var dat1 = new Date(arrStDt[0], arrStDt[1], arrStDt[2]);
            var dat2 = new Date(arrEnDt[0], arrEnDt[1], arrEnDt[2]);
            var diff = dat2 - dat1;
            if(diff < 0){
            	AUIGrid.selectRowsByRowId(myGridID, udtList[i].rnum);            // id값을 설정하고, 셋팅 하면 된다.
            	result = false;
            	Common.alert("The start date can be greater than the end date.");
            	break;
            }

            if (js.String.isEmpty(cur)){
                result = false;
                Common.alert("Please select a CUR.");
                break;
            }

            if (js.String.isEmpty(purchsPrc)){
                result = false;
                Common.alert("Please input the price.");
                break;
            }

            if (js.String.isEmpty(uom)){
                result = false;
                Common.alert("Please select a UOM.");
                break;
            }
        }
    	return result;
    }

    function cellClickEvent( event ){
        console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
        //var gSelRowIdx = event.rowIndex;

        if (AUIGrid.isAddedById(myGridID,AUIGrid.getCellValue(myGridID, event.rowIndex, 0)) == true
                || String(event.value).length < 1){
            return false;
        }

        var priceSeqNo = AUIGrid.getCellValue(myGridID, event.rowIndex, "priceSeqNo");

        if(priceSeqNo != oldSeqNo){
        	AUIGrid.setGridData(detailGridID, []);
	        if(js.String.isEmpty(priceSeqNo)){
	        	oldSeqNo = priceSeqNo;
	            return false;
	        }

	        //var subParam = "&sPriceSeqNo="+priceSeqNo;
	        var subParam = {"sPriceSeqNo":priceSeqNo};

	        Common.ajax("GET", "/homecare/po/selectHcPurchasePriceHstList.do"
	                , subParam
	                , function(result){
	                       console.log("data : " + result);
	                       AUIGrid.setGridData(detailGridID, result.dataList);
	        });
        }

        oldSeqNo = priceSeqNo;
    }

    /**
    * dd-mm-yyyy 날짜 형식을 체크함.
    */
    function fn_isDateValidate(sValidDt){
    	// 날짜형식 체크
        //var date_pattern = /^(0[1-9]|[12][0-9]|3[0-1])-(0[1-9]|1[012])-(19|20)\d{2}$/;      // dd-MM-yyyy
        var date_pattern = /^(19|20)\d{2}\/(0[1-9]|1[012])\/(0[1-9]|[12][0-9]|3[0-1])$/;      // yyyy/MM/dd

        if( sValidDt != null && sValidDt != ""
            && !date_pattern.test(sValidDt)
        ) {
            return false;
        }
        return true;
    }

</script>
</head>

<section id="content"><!-- content start -->
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif"
                alt="Home" /></li>
        <li>Homecare</li>
        <li>SCM</li>
        <li>Purchase Price(HC)</li>
    </ul>

    <aside class="title_line"><!-- title_line start -->
        <p class="fav"><a href="#none" class="click_add_on">My menu</a></p>
        <h2>Purchase Price</h2>

        <ul class="right_btns">
	    <c:if test="${PAGE_AUTH.funcView == 'Y'}">
	        <li><p class="btn_blue"><a id="search"><span class="search"></span>Search</a></p></li>
	    </c:if>
        </ul>
    </aside><!-- title_line end -->

    <section class="search_table"><!-- search_table start -->
    <form id="searchForm" method="post" onsubmit="return false;">
        <input type="hidden" id="svalue" name="svalue"/>
        <input type="hidden" id="isgubun"   name="isgubun"  />
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
                    <th scope="row"><span style="color:red">*</span>Supplier</th>
                    <td>
                        <select id="sMemAccId" name="sMemAccId" placeholder="" class="w100p" >
                    </td>
                    <th scope="row">Material Code</th>
		            <td>
		                <input type="text" id="sStkCd" name="sStkCd"  placeholder="" class="w100p" />
		                <input type="hidden" id="sStkNm" name="sStkNm"  placeholder="" class="" />
		                <%-- <a href="#none" class="search_btn" id="search_material_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a> --%>
		            </td>
                    <th scope="row">Category</th>
                    <td>
                        <select id="sCategory" name="sCategory" title="" placeholder="" class="w100p" >
                    </td>
                </tr>
                <tr>
                    <th scope="row">Valid Date</th>
                    <td>
                        <input type="text" title="Valid Date" placeholder="DD-MM-YYYY" class="j_date0 w100p" id="sValidDt" name="sValidDt" />
                        <!-- <label><input type="checkbox" id="sChkOnly" name="sChkOnly" /><span>Only Display valid date.</span></label> -->
                    </td>
                    <th scope="row">Type</th>
                    <td>
                        <select id="sType" name="sType" class="w100p" >
                    </td>
                    <th scope="row"></th>
                    <td></td>
                </tr>
            </tbody>
        </table><!-- table end -->
    </form>
    </section><!-- search_table end -->

    <!-- data body start -->
  <section class="search_result"><!-- search_result start -->
    <aside class="title_line"><!-- title_line start -->
      <ul class="right_btns">
        <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
          <li><p class="btn_grid"><a id="btnSave">Save</a></p></li>
        </c:if>
      </ul>
    </aside><!-- title_line end -->
    <!-- grid_wrap start -->
    <article class="grid_wrap">
       <!-- 그리드 영역1 -->
       <div id="mainGrid" style="height:330px;"></div>

       <!-- 그리드 페이징 네비게이터 -->
       <div id="grid_paging" class="aui-grid-paging-panel my-grid-paging-panel"></div>
    </article>
    <!-- grid_wrap end -->

    <aside class="title_line"><!-- title_line start -->
       <h3>History</h3>
    </aside><!-- title_line end -->
    <article class="grid_wrap" ><!-- grid_wrap start -->
      <!--  그리드 영역2  -->
      <div id="subGrid" class="autoGridHeight"></div>
    </article><!-- grid_wrap end -->

    </section><!-- data body end -->

</section><!-- content end -->