<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>


<!-- 
####################################
AUIGrid Hompage     : http://www.auisoft.net/price.html
Grid Documentation  : http://www.auisoft.net/documentation/auigrid/index.html
####################################
 -->    
    <script type="text/javaScript" language="javascript">
    
 // AUIGrid 생성 후 반환 ID
    var myGridID;

    $(document).ready(function(){
    	
    	// http://www.auisoft.net/documentation/auigrid/index.html
    	var options = {
    			useContextMenu : false,
    			pagingMode : "simple"
    	};
        
        // AUIGrid 그리드를 생성합니다.
        myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, "id", options);
        
        // 푸터 객체 세팅
        AUIGrid.setFooter(myGridID, footerObject);
        
        // 에디팅 시작 이벤트 바인딩
        AUIGrid.bind(myGridID, "cellEditBegin", auiCellEditingHandler);

        // 에디팅 정상 종료 이벤트 바인딩
        AUIGrid.bind(myGridID, "cellEditEnd", auiCellEditingHandler);
        
        // 에디팅 취소 이벤트 바인딩
        AUIGrid.bind(myGridID, "cellEditCancel", auiCellEditingHandler);
        
        // 행 추가 이벤트 바인딩 
        AUIGrid.bind(myGridID, "addRow", auiAddRowHandler);
        
        // 행 삭제 이벤트 바인딩 
        AUIGrid.bind(myGridID, "removeRow", auiRemoveRowHandler);
        
        
        // 삭제 전 확인을 하고자 한다면 주석 제거 하세요.
        // 행 삭제 전 이벤트 바인딩 
        /*AUIGrid.bind(myGridID, "beforeRemoveRow", function(event) {
            var message = "삭제 확인\r" + event.type + " 이벤트 ( softRemoveRowMode : " + event.softRemoveRowMode + ")\r\n";
            message += "삭제할 개수 : " + event.items.length;
            
            var retVal = confirm(message);
            
            return retVal;
        });*/
        
        fn_getSampleListAjax();

    });

    // AUIGrid 칼럼 설정
    // 데이터 형태는 다음과 같은 형태임,
    //[{"id":"#Cust0","date":"2014-09-03","name":"Han","product":"Apple","color":"Red","price":746400}, { .....} ];
    var columnLayout = [ {
            dataField : "id",
            headerText : "id",
            width : 120
        }, {
            dataField : "name",
            headerText : "Name",
            width : 120
        }, {
            dataField : "description",
            headerText : "description",
            width : 120
        }, {
            dataField : "product",
            headerText : "Product",
            width : 120
        }, {
            dataField : "color",
            headerText : "Color",
            width : 120
        }, {
            dataField : "price",
            headerText : "Price",
            dataType : "numeric",
            style : "my-column",
            width : 120
        }, {
            dataField : "quantity",
            headerText : "Quantity",
            dataType : "numeric",
            width : 120
        }, {
            dataField : "date",
            headerText : "Date",
            width : 120
        }];
    
 // 푸터 설정
    var footerObject = [ {
	        labelText : "∑",
	        positionField : "#base"
	    }, {
	        dataField : "price",
	        positionField : "price",
	        operation : "SUM",
	        formatString : "#,##0",
	        style : "aui-grid-my-footer-sum-total"
	    }, {
	        dataField : "price",
	        positionField : "date",
	        operation : "COUNT",
	        style : "aui-grid-my-footer-sum-total2"
	    }, {
	        labelText : "Count=>",
	        positionField : "phone",
	        style : "aui-grid-my-footer-sum-total2"
	    }];


    
    // ajax list 조회.
    function fn_getSampleListAjax() {        
        Common.ajax("GET", "/sample/selectJsonSampleList", $("#searchForm").serialize(), function(result) {
            console.log("성공.");
            console.log("data : " + result);
            AUIGrid.setGridData(myGridID, result);
        });
    }
    

    function auiCellEditingHandler(event) {
        if(event.type == "cellEditBegin") {
            document.getElementById("editBeginDesc").innerHTML = "에디팅 시작(cellEditBegin) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value + ", which : " + event.which;
        } else if(event.type == "cellEditEnd") {
            document.getElementById("editBeginEnd").innerHTML = "에디팅 종료(cellEditEnd) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value + ", which : " + event.which;
        } else if(event.type == "cellEditCancel") {
            document.getElementById("editBeginEnd").innerHTML = "에디팅 취소(cellEditCancel) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value + ", which : " + event.which;
        } else if(event.type == "cellEditEndBefore") {
            // 여기서 반환하는 값이 곧 에디팅 완료 값입니다.
            // 개발자가 입력한 값을 변경할 수 있습니다.
            return event.value; // 원래 값으로 적용 시킴
        }
    };

    // 셀렉션 체인지 핸들러
    function auiSelectionChangeHandler(event) {
        var selectedItems = event.selectedItems;
        if(selectedItems.length <= 0)
            return;
        
        var firstItem = selectedItems[0]; 
        
        // 하단에 행인덱스, 헤더 텍스트, 수정 가능여부 출력함.
        document.getElementById("selectionDesc").innerHTML = "현재 셀 : ( " + firstItem.rowIndex + ", " + firstItem.headerText + " ) : editable : " + firstItem.editable + ", 행 고유값(PK) : " + firstItem.rowIdValue;
            
        // 해당 셀의 행 아이템 
        //var rowItem = firstItem.item; // 행 아이템들
        // 칼럼과 관계없이 현재 행의 Name 값을 보고자 한다면
        //alert(rowItem.name);
    };

    //keepEditing 토글
    function toggleKeepEditing() {
        var chkbox = document.getElementById("chkbox");
        AUIGrid.setProp(myGridID, "keepEditing", chkbox.checked);
    }

    function toggleEditMode() {
        var editBeginMode = AUIGrid.getProp(myGridID, "editBeginMode");
        
        if(editBeginMode == "doubleClick") {
            AUIGrid.setProp(myGridID, "editBeginMode", "click");
            document.getElementById("status").innerHTML = "click";
        }
        else {
            AUIGrid.setProp(myGridID, "editBeginMode", "doubleClick");
            document.getElementById("status").innerHTML = "doubleClick";
        }
    };

    //editingOnKeyDown 토글
    function toggleEditingOnKeyDown() {
        var downChkbox = document.getElementById("downChkbox");
        AUIGrid.setProp(myGridID, "editingOnKeyDown", downChkbox.checked); //editingOnKeyDown 토글
    };

    //onlyEnterKeyEditEnd 토글
    function toggleOnlyEnterKeyEditEnd() {
        var enterChkbox = document.getElementById("enterChkbox");
        AUIGrid.setProp(myGridID, "onlyEnterKeyEditEnd", enterChkbox.checked); //onlyEnterKeyEditEnd 토글
    };

    //enterKeyColumnBase 토글
    function toggleOnlyEnterKeyColumn() {
        var enterColChkbox = document.getElementById("enterColChkbox");
        AUIGrid.setProp(myGridID, "enterKeyColumnBase", enterColChkbox.checked); //enterKeyColumnBase 토글
    };
    

	 // 행 추가 이벤트 핸들러
	 function auiAddRowHandler(event) {
	     //alert(event.type + " 이벤트\r\n" + "삽입된 행 인덱스 : " + event.rowIndex + "\r\n삽입된 행 개수 : " + event.items.length);
	     document.getElementById("rowInfo").innerHTML = (event.type + " 이벤트 :  " + "삽입된 행 인덱스 : " + event.rowIndex + ", 삽입된 행 개수 : " + event.items.length);
	 }
	
	 // 행 삭제 이벤트 핸들러
	 function auiRemoveRowHandler(event) {
	     document.getElementById("rowInfo").innerHTML = (event.type + " 이벤트 :  " + ", 삭제된 행 개수 : " + event.items.length + ", softRemoveRowMode : " + event.softRemoveRowMode);
	 }
	
	 var countries = ["Korea", "USA",  "UK", "Japan", "China", "France", "Italy", "Singapore", "Ireland", "Taiwan"];
	 var products = new Array("IPhone 5S", "Galaxy S5", "IPad Air", "Galaxy Note3", "LG G3", "Nexus 10");
	 var colors = new Array("Blue", "Gray", "Green", "Orange", "Pink", "Violet", "Yellow", "Red");
	
	 var cnt = 0;
	
	 // 행 추가, 삽입
	 function addRow() {
	     
	     var rowPos = document.getElementById("addSelect").value;
	     
	     var item = new Object();
	     item.name = "AUI-" + (++cnt),
	     //item.aaa = "aaa",  // 서버에서 VO로 처리시 VO 에 정의 되지 않은 값을 넘긴다면 에러 발생, 맵은 상관없음.
	     item.color = colors[cnt % colors.length],
	     item.product = products[cnt % products.length],
	     item.price = Math.floor(Math.random() * 1000000),
	     item.date = "2015/03/05"
	
	     // parameter
	     // item : 삽입하고자 하는 아이템 Object 또는 배열(배열인 경우 다수가 삽입됨)
	     // rowPos : rowIndex 인 경우 해당 index 에 삽입, first : 최상단, last : 최하단, selectionUp : 선택된 곳 위, selectionDown : 선택된 곳 아래
	     AUIGrid.addRow(myGridID, item, rowPos);
	 }
	
	 // 다수의 행 추가, 삽입
	 function addRowMultiple() {
	     
	     var rowPos = document.getElementById("multipleAddSelect").value;
	     
	     var item;
	     var rowList = [];
	     var rowCnt = Math.floor(Math.random() * 10); // 랜덤 개수
	     rowCnt = Math.max(2, rowCnt);
	     
	     // 추가시킬 행 10개 작성
	     for(var i=0; i<rowCnt; i++) { 
	         rowList[i] = {
	             name : "AUI-" + (++cnt),
	             color : colors[cnt % colors.length],
	             product : products[cnt % products.length],
	             price : Math.floor(Math.random() * 1000000),
	             date : "2015/03/05"
	         }
	     }
	
	     // parameter
	     // item : 삽입하고자 하는 아이템 Object 또는 배열(배열인 경우 다수가 삽입됨)
	     // rowPos : rowIndex 인 경우 해당 index 에 삽입, first : 최상단, last : 최하단, selectionUp : 선택된 곳 위, selectionDown : 선택된 곳 아래
	     AUIGrid.addRow(myGridID, rowList, rowPos);
	 }
	
	 // 행 삭제
	 function removeRow() {
	     
	     var rowPos = document.getElementById("removeSelect").value;
	         
	     AUIGrid.removeRow(myGridID, rowPos);
	 }
	
	 // 삭제해서 마크 된(줄이 그어진) 행을 복원 합니다.(삭제 취소)
	 function restoreSoftRows() {
	     
	     var flag = document.getElementById("cacnelSelect").value;
	     
	     if(flag == "all") {
	         // 전체 삭제 취소
	         AUIGrid.restoreSoftRows(myGridID, "all");
	     } else {
	         // 선택 행 삭제 취소(선택 행이 삭제 됐다면...)
	         AUIGrid.restoreSoftRows(myGridID, "selectedIndex");
	     }
	     
	 }
	
	
	 function resetUpdatedItems() {
	     
	     // 모두 초기화.
	     AUIGrid.resetUpdatedItems(myGridID, "a");
	 }
	 
	//추가, 수정, 삭제 된 아이템들 확인하기
	 function checkItems() {
	     
	     // 추가된 행 아이템들(배열)
	     var addedRowItems = AUIGrid.getAddedRowItems(myGridID);
	      
	     // 수정된 행 아이템들(배열)
	     var editedRowItems = AUIGrid.getEditedRowColumnItems(myGridID); 
	     
	     // 삭제된 행 아이템들(배열)
	     var removedRowItems = AUIGrid.getRemovedItems(myGridID);
	     
	     var i, len, name, rowItem;
	     var str = "";
	     
	     if(addedRowItems.length > 0) {
	         str += "---추가된 행\r\n";
	         for(i=0, len=addedRowItems.length; i<len; i++) {
	             rowItem = addedRowItems[i]; // 행아이템
	             // 전체 조회
	             for(var name in rowItem) {
	                 str += name + " : " + rowItem[name] + ", "; 
	             }
	             str += "\r\n";
	         }
	     }
	     
	     if(editedRowItems.length > 0) {
	         str += "---수정된 행\r\n";
	         for(i=0, len=editedRowItems.length; i<len; i++) {
	             rowItem = editedRowItems[i]; // 행아이템
	             
	             // 전체 조회
	             for(var name in rowItem) {
	                 str += name + " : " + rowItem[name] + ", "; 
	             }
	             str += "\r\n";
	         }
	     }
	     
	     if(removedRowItems.length > 0) {
	         str += "---삭제된 행\r\n";
	         for(i=0, len=removedRowItems.length; i<len; i++) {
	             rowItem = removedRowItems[i]; // 행아이템
	             // 전체 조회
	             for(var name in rowItem) {
	                 str += name + " : " + rowItem[name] + ", "; 
	             }
	             str += "\r\n";
	         }
	     }
	     
	     
	     // 하단에 정보 출력.
	     $("#desc_info").html("추가 개수 : " + addedRowItems.length + ", 수정 개수 : " + editedRowItems.length + ", 삭제 개수 : " + removedRowItems.length); 
	     
	     
	     if(str == "")
	         str = "변경 사항 없음";
	     
	     alert(str);
	 }
	
	//서버로 전송.
    function fn_saveSampleGridMap(){
    	Common.ajax("POST", "/sample/saveSampleGridByMap.do", GridCommon.getEditData(myGridID), function(result) {
    		alert("성공");
            resetUpdatedItems(); // 초기화
            console.log("성공.");
            console.log("data : " + result);
        },  function(jqXHR, textStatus, errorThrown) {
        	try {
                console.log("status : " + jqXHR.status);
                console.log("code : " + jqXHR.responseJSON.code);
                console.log("message : " + jqXHR.responseJSON.message);
                console.log("detailMessage : "
                        + jqXHR.responseJSON.detailMessage);
            } catch (e) {
                console.log(e);
            }

            alert("Fail : " + jqXHR.responseJSON.message);
            
            fn_getSampleListAjax();
        });
	}

    //서버로 전송.
    function fn_saveSampleGridVO(){
        Common.ajax("POST", "/sample/saveSampleGridByVO.do", GridCommon.getEditData(myGridID), function(result) {
        	alert("성공");
        	resetUpdatedItems(); // 초기화
            console.log("성공.");
            console.log("data : " + result);
        },  function(jqXHR, textStatus, errorThrown) {
        	try {
                console.log("status : " + jqXHR.status);
                console.log("code : " + jqXHR.responseJSON.code);
                console.log("message : " + jqXHR.responseJSON.message);
                console.log("detailMessage : "
                        + jqXHR.responseJSON.detailMessage);
            } catch (e) {
                console.log(e);
            }

            alert("Fail : " + jqXHR.responseJSON.message);
        	
            fn_getSampleListAjax();
        });
    }
    
    // 삭제해서 마크 된(줄이 그어진) 행을 복원 합니다.(삭제 취소)
    function restoreSoftRows() {
    	// 전체 삭제 취소
        AUIGrid.restoreSoftRows(myGridID, "all");
    }
    
    </script>


<div class="wrap">        
        <div id="content_pop">
            <!-- 타이틀 -->
            <div id="title">
                <ul>
                    <li><img src="<c:url value='/resources/images/egovframework/example/title_dot.gif'/>" alt=""/><spring:message code="list.sample" /></li>
                </ul>
            </div>
            
            <form id="searchForm" method="get" action="">
                 id : <input type="text" id="sId" name="sId"/><br/>
                 name : <input type="text" id="sName" name="sName"/><br/>
                 
                 <input type="button" class="btn" onclick="javascript:fn_getSampleListAjax();" value="조회"/>
             </form>
            
            
            <div class="desc">
		        <p>■편집 하기 : 키보드 바로 입력 또는 (더블) 클릭, ■편집 종료 : Enter 키 또는 Tab 키 또는 다른 셀 선택, ■편집 취소 : ESC 키</p>
		        <p>■키보드 화살표키 : 각 방향으로 이동, ■Enter : 아래로, ■Shift + Enter : 위로, ■Tab : 오른쪽으로, ■Shift + Tab : 왼쪽으로<p>
		        <p>■Home : 최상단으로, ■End : 최하단으로, ■PgUp : 한 페이지 위로, ■PgDown : 한 페이지 아래로</p>
		        <p>■Insert : 행 추가, ■Ctrl+Insert : 하단에 행추가, ■Ctrl+Delete : 행 삭제</p>
		        <p style="padding-top:5px;"><input type="checkbox" id="downChkbox" checked="checked" onclick="toggleEditingOnKeyDown()" 
		            style="vertical-align:middle;">
		            <label for="downChkbox">editingOnKeyDown (키보드 입력으로 바로 편집할 수 있는지 여부) - 자세한 설명은 기본 그리드 편집2 데모 참고</label></p>
		        <p style="padding-top:5px;"><input type="checkbox" id="chkbox"  onclick="toggleKeepEditing()"
		            style="vertical-align:middle;">
		            <label for="chkbox">keepEditing (탭이나 엔터키로 완료할 때 다음 셀을 편집가능 상태로 만들지 여부(F2키, 더블클릭으로 진입한 상태에만 유효)</label></p>
		            
		        <p style="padding-top:5px;"><input type="checkbox" id="enterColChkbox"  checked="checked"  onclick="toggleOnlyEnterKeyColumn()"
		            style="vertical-align:middle;">
		            <label for="enterColChkbox">enterKeyColumnBase (엔터키가 다음 행이 아닌 다음 칼럼으로 이동함)</label></p>
		            
		        <p style="padding-top:5px;"><input type="checkbox" id="enterChkbox"  onclick="toggleOnlyEnterKeyEditEnd()"
		            style="vertical-align:middle;">
		            <label for="enterChkbox">onlyEnterKeyEditEnd (엔터키가 편집 완료 역할만 할 뿐 다음 행으로 이동하지 않음, keepEditing, enterKeyColumnBase 속성 보다 우선 순위 높음)</label></p>
		        <P></p>
		        <span class="btn" onclick="toggleEditMode()">클릭/더블클릭 토글</span>Current editBeginMode : <span id="status"> doubleClick</span>
		        <P></p>
		    </div>
		            
            <div class="desc">
		        <ul class="nav_u">
		            <li>■ 단일 행 추가 : </li>
		            <li><select id="addSelect">
		                <option value="first" selected="selected">최상단에 행추가</option>
		                <option value="selectionUp">선택 행 위에 추가</option>
		                <option value="selectionDown">선택 행 아래에 추가</option>
		                <option value="5">rowIndex 5에 추가</option>
		                <option value="last">최하단에 행추가</option>
		            </select></li>
		            <li><input type="button" class="btn" onclick="addRow()" value="추가하기"></li>
		        </ul>
		        
		        <ul class="nav_u">
		            <li>■ 다수의 행 추가 : </li>
		            <li><select id="multipleAddSelect">
		                <option value="first" selected="selected">다수의 행 최상단에에 삽입</option>
		                <option value="last">다수의 행 최하단 추가</option>
		            </select>   </li>
		            <li><input type="button" class="btn" onclick="addRowMultiple()" value="추가하기"></li>
		        </ul>
		        
		        <ul class="nav_u">
		            <li>■ 행 삭제 : </li>
		            <li><select id="removeSelect">
		                <option value="selectedIndex" selected="selected">선택 행(들) 삭제</option>
		                <option value="5">rowIndex 5 삭제</option>
		            </select></li>
		            <li><input type="button" class="btn" onclick="removeRow()" value="삭제하기"></li>
		            
		            <li><select id="cacnelSelect">
		                <option value="selectedIndex" selected="selected">선택행 삭제 아이템 복원(삭제 취소)</option>
		                <option value="all">전체 삭제 아이템들 복원</option>
		            </select></li>
		            <li><input type="button" class="btn" onclick="restoreSoftRows()" value="복원하기"></li>
		        </ul>
		        
		        <p><span onclick="resetUpdatedItems()" class="btn">그리드 추가, 수정, 삭제 상태 정보 초기화</span></p>
		        
		    </div>
            <!-- grid -->
            <div id="main">
                <div>
                    <!-- 에이유아이 그리드가 이곳에 생성됩니다. -->
                    <div id="grid_wrap" style="width:800px; height:300px; margin:0 auto;"></div>
                </div>
                
                <div class="desc_bottom">
			        <p id="rowInfo"></p>
			        <p id="editBeginDesc"></p>
			        <p id="editBeginEnd"></p>
			    </div>
			    
			    <div class="desc_bottom">
				    <p><span onclick="checkItems()" class="btn">추가, 삭제, 수정된 아이템 확인하기</span></p>
				    <P></p>
			        <p>■ 추가 아이템 : 기존 데이터가 아닌 새로 사용자에 의해 추가된 아이템을 말합니다.</p>
			        <p>■ 수정 아이템 : 기존 데이터를 수정한 경우를 말합니다. </p>
			        <P>추가된 아이템을 수정한 경우 기본적으로 수정 아이템이 아닌 추가 아이템으로 등록됩니다.</p>
			        <P>즉, 추가된 아이템은 DB에 없는 데이터였으므로 update 의미가 없습니다.</p>
			        <P>(추가 후 수정했더라도 추가 아이템임)</p>
			        <p>■ 삭제 아이템 : 기존 데이터를 삭제한 경우를 말합니다.</p>
			        <P> 추가된 아이템을 삭제한 경우 추가 아이템, 삭제 아이템에 등록되지 않습니다.</p>
			        <P>(추가 후 삭제는 DB 까지 갈 필요 없음. insert, delete 의 의미가 없음.)</p>
			        <P>만약, 사용자가 추가한 행을 다시 삭제한 아이템 까지 얻고자 한다면</p>
			        <P> AUIGrid.getRemovedItems(myGridID, true); 를 사용하십시오.</p>
			        <P></p>
			        <p><span onclick="fn_saveSampleGridMap();" class="btn">서버로 전송 - Map이용.</span></p>
			        <P></p>
			        <P></p>
			        <p><span onclick="fn_saveSampleGridVO();" class="btn">서버로 전송 - VO이용.</span></p>
			        <P></p>
				</div>

            </div>
        </div>
</div>
