<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javaScript">

	//Defalut MultiCombo
	function fn_multiCombo() {
		$('#cmbCategory').change(function() {
		}).multipleSelect({
			selectAll : true, // 전체선택 
			width : '100%'
		});
	}
	
	  
	// Make AUIGrid 
	var myGridID;

	//Start AUIGrid
	$(document).ready(function() {
		
		// AUIGrid 그리드를 생성합니다.

		myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,"seq");

		// cellClick event.
		AUIGrid.bind(myGridID, "cellClick", function(event) {
			console.log("rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");			
		});		
		
		AUIGrid.bind(myGridID, "cellEditBegin", auiCellEditingHandler);      // 에디팅 시작 이벤트 바인딩
		AUIGrid.bind(myGridID, "cellEditEnd", auiCellEditingHandler);        // 에디팅 정상 종료 이벤트 바인딩
		AUIGrid.bind(myGridID, "cellEditCancel", auiCellEditingHandler);    // 에디팅 취소 이벤트 바인딩
		AUIGrid.bind(myGridID, "addRow", auiAddRowHandler);               // 행 추가 이벤트 바인딩 
		AUIGrid.bind(myGridID, "removeRow", auiRemoveRowHandler);     // 행 삭제 이벤트 바인딩 
		
		//Rule Book Item search
		$("#search").click(function(){	
			
			var searchDt = $("#searchDt").val();
			if(searchDt!=""){
				 $("#year").val(searchDt.substring(3));
				 $("#month").val(searchDt.substring(0,2));
			}			
			Common.ajax("GET", "/commission/system/selectWeeklyList", $("#searchForm").serialize(), function(result) {
				console.log("성공.");
				console.log("data : " + result);
				AUIGrid.setGridData(myGridID, result);
			});
	   });
		
	    //아이템 grid 행 추가
	    $("#addRow").click(function() {	
	   	  var searchDt = $("#searchDt").val();
	      var item = new Object();
	      item.year = searchDt.substring(3);
	      item.month = searchDt.substring(0,2);
	      item.weeks = "";
	      item.startDt = "";
	      item.endDt = "";
	      
	      var month = 0; 
          var weekObj  = new Array();
          var week=0;
          var chkVal = -1;
        
	      for(var i=0;i< AUIGrid.getGridData(myGridID).length ;i++){
	          month = AUIGrid.getCellValue(myGridID, i, 2);
	          if(month == parseInt(item.month,10)){
	        	  weekObj[i]  = AUIGrid.getCellValue(myGridID, i, 3); 
	          }
	      }	      
	      
	      if(weekObj.length>=4){
	    	  Common.alert("All Week has already been added.");
	    	  return;
	      }else{
	    	  var w1=$.inArray(1,weekObj);
	    	  var w2=$.inArray(2,weekObj);
	    	  var w3=$.inArray(3,weekObj);
	    	  var w4=$.inArray(4,weekObj);
	    	  
	    	  if(w1==chkVal){
	              item.weeks=1; 
	        }else if(w2==chkVal){
	            item.weeks=2;
	        }else if(w3==chkVal){
	            item.weeks=3;
	        }else if(w4==chkVal){
	            item.weeks=4;
	        }
	      }
	   
	      // parameter
	      // item : 삽입하고자 하는 아이템 Object 또는 배열(배열인 경우 다수가 삽입됨)
	      // rowPos : rowIndex 인 경우 해당 index 에 삽입, first : 최상단, last : 최하단, selectionUp : 선택된 곳 위, selectionDown : 선택된 곳 아래
	      AUIGrid.addRow(myGridID, item, "first");
	    });
	    
	  //Weekly save
        $("#save").click(function() {
            if (validation()) {
                Common.confirm("<spring:message code='sys.common.alert.save'/>",fn_saveGridData);
            }
        });
	  
	});//Ready
	
	 function fn_saveGridData(){
	        Common.ajax("POST", "/commission/system/saveCommissionWeeklyGrid.do", GridCommon.getEditData(myGridID), function(result) {
	            // 공통 메세지 영역에 메세지 표시.
	            Common.setMsg("<spring:message code='sys.msg.success'/>");
	            $("#search").trigger("click");
	        }, function(jqXHR, textStatus, errorThrown) {
	            try {
	                console.log("status : " + jqXHR.status);
	                console.log("code : " + jqXHR.responseJSON.code);
	                console.log("message : " + jqXHR.responseJSON.message);
	                console.log("detailMessage : " + jqXHR.responseJSON.detailMessage);
	            } catch (e) {
	                console.log(e);
	            }
	            Common.alert("Fail : " + jqXHR.responseJSON.message);	          
	        });
	    }

	//event management
	function auiCellEditingHandler(event) {
		var value = AUIGrid.getCellValue(myGridID, event.rowIndex, event.columnIndex);
		if (event.type == "cellEditEnd") {
			if (event.columnIndex == 1) {			    
			     if (value >= 10000 ) {
			    	 AUIGrid.setCellValue(myGridID, event.rowIndex, event.columnIndex,"");
			     }
			}else  if (event.columnIndex == 2) {		        
		        if (value > 12 ) {
		        	 AUIGrid.setCellValue(myGridID, event.rowIndex, event.columnIndex,"");
		        }
		  }else  if (event.columnIndex == 3) {          
            if (value > 4 ) {
           	  AUIGrid.setCellValue(myGridID, event.rowIndex, event.columnIndex,"");
            }
     }else  if (event.columnIndex == 5) {           
    	 var stVal =AUIGrid.getCellValue(myGridID, event.rowIndex, event.columnIndex-1);       
         if(parseInt(value.replace(/\//g,""))<=parseInt(stVal.replace(/\//g,""))){
           //Common.alert("Please enter a value greater than Start Date");
           Common.setMsg("<spring:message code='commission.alert.dateGreaterCheck'/>");
           AUIGrid.setCellValue(myGridID, event.rowIndex, event.columnIndex,"");
         }    
    }      
		} else if (event.type == "cellEditBegin") {
			 if (event.columnIndex == 5) {         
				  var stVal =AUIGrid.getCellValue(myGridID, event.rowIndex, event.columnIndex-1);				
		           if (stVal == "" ) {
		        	   Common.alert("<spring:message code='sys.common.alert.validation' arguments='START DATE' htmlEscape='false'/>");
		             return false;
		           }
		      }
		}
	}
	// 행 추가 이벤트 핸들러
    function auiAddRowHandler(event) {
	}
    // 행 삭제 이벤트 핸들러
    function auiRemoveRowHandler(event) {
    }

	// Weekly AUIGrid 칼럼 설정
	var columnLayout = [{
	    dataField : "seq",
	    headerText : "<spring:message code='commission.text.grid.seq'/>",
	    width : 0,
	    visible : false
	  }, {
		dataField : "year",
		headerText : "<spring:message code='commission.text.grid.year'/>",
		dataType : "numeric",	
		editRenderer : {
			  type : "InputEditRenderer",
			  showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
			  onlyNumeric : true, // 0~9만 입력가능
			  allowPoint : false, // 소수점( . ) 도 허용할지 여부
			  allowNegative : false, // 마이너스 부호(-) 허용 여부
			  textAlign : "right", // 오른쪽 정렬로 입력되도록 설정
			  autoThousandSeparator : false // 천단위 구분자 삽입 여부			 
			},
		formatString : "###0",	
		width : "10%"
	}, {
		dataField : "month",
        headerText : "<spring:message code='commission.text.grid.month'/>",
        dataType : "numeric", 
        editRenderer : {
            type : "InputEditRenderer",
            showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
            onlyNumeric : true, // 0~9만 입력가능
            allowPoint : false, // 소수점( . ) 도 허용할지 여부
            allowNegative : false, // 마이너스 부호(-) 허용 여부
            textAlign : "right", // 오른쪽 정렬로 입력되도록 설정
            autoThousandSeparator : false // 천단위 구분자 삽입 여부          
          },
        width : "10%"
	}, {
		dataField : "weeks",
        headerText : "<spring:message code='commission.text.grid.keeks'/>",
        dataType : "numeric", 
        editRenderer : {
            type : "InputEditRenderer",
            showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
            onlyNumeric : true, // 0~9만 입력가능
            allowPoint : false, // 소수점( . ) 도 허용할지 여부
            allowNegative : false, // 마이너스 부호(-) 허용 여부
            textAlign : "right", // 오른쪽 정렬로 입력되도록 설정
            autoThousandSeparator : false // 천단위 구분자 삽입 여부
          },
          width : "10%"
	},{
		dataField : "startDt",
        headerText : "<spring:message code='commission.text.grid.startDate'/>",
        dataType : "date",
        formatString : "yyyy/mm/dd",
        width:160,
        editRenderer : {
          type : "CalendarRenderer",
          showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 출력 여부
          onlyCalendar : false, // 사용자 입력 불가, 즉 달력으로만 날짜입력 (기본값 : true)
          showExtraDays : true // 지난 달, 다음 달 여분의 날짜(days) 출력
        },
        width : "10%"
	},  {
        dataField : "endDt",
        headerText : "<spring:message code='commission.text.grid.endDate'/>",
        dataType : "date",
        formatString : "yyyy/mm/dd",
        width:160,
        editRenderer : {
          type : "CalendarRenderer",
          showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 출력 여부
          onlyCalendar : false, // 사용자 입력 불가, 즉 달력으로만 날짜입력 (기본값 : true)
          showExtraDays : true // 지난 달, 다음 달 여분의 날짜(days) 출력
        },
        width : "10%"
    }];
	
	/*  validation */
	  function validation() {
	    var result = true;
	    var addList = AUIGrid.getAddedRowItems(myGridID);
	    var udtList = AUIGrid.getEditedRowItems(myGridID);
	    if (addList.length == 0 && udtList.length == 0) {
	      Common.alert("<spring:message code='sys.common.alert.noChange'/>");
	      return false;
	    }
	    if(!validationCom(addList) || !validationCom(udtList)){
	    	return false;
	    }	   
	    return result;
	  }
	
	function validationCom(list){
		 var result = true;
		 for (var i = 0; i < list.length; i++) {
		        var year = list[i].year;
		        var month = list[i].month;
		        var weeks = list[i].weeks;
		        var startDt = list[i].startDt;
		        var endDt = list[i].endDt; 
		        if (year == "") {
		          result = false;
		          Common.alert("<spring:message code='sys.common.alert.validation' arguments='YEAR' htmlEscape='false'/>");
		          break;
		        } else if (month == "" ) {
		          result = false;
		          Common.alert("<spring:message code='sys.common.alert.validation' arguments='MONTH' htmlEscape='false'/>");
		          break;
		        } else if (weeks == "") {
		          result = false;
		          Common.alert("<spring:message code='sys.common.alert.validation' arguments='WEEKS' htmlEscape='false'/>");
		          break;
		        } else if (startDt == "") {
		          result = false;
		          Common.alert("<spring:message code='sys.common.alert.validation' arguments='START DATE' htmlEscape='false'/>");
		          break;
		        }else if (endDt == "") {
		            result = false;
		            Common.alert("<spring:message code='sys.common.alert.validation' arguments='END DATE' htmlEscape='false'/>");
		            break;
		          }
		      }
		 return result;
	}
</script>


<section id="content">
	<!-- content start -->
	<ul class="path">
		<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
        <li><spring:message code='commission.text.head.commission'/></li>
        <li><spring:message code='commission.text.head.masterMgmt'/></li>
        <li><spring:message code='commission.text.head.weeklyMgmt'/></li>
	</ul>

	<aside class="title_line">
		<!-- title_line start -->
		<p class="fav">
			<a href="#" class="click_add_on">My menu</a>
		</p>
		<h2><spring:message code='commission.title.weekly'/></h2>

		<ul class="right_btns">
            <c:if test="${PAGE_AUTH.funcView == 'Y'}">
				<li><p class="btn_blue"> 
						<a href="#"  id="search" ><span class="search"></span><spring:message code='sys.btn.search'/></a>
					</p></li>
            </c:if>
		</ul>

	</aside>
	<!-- title_line end -->

	<section class="search_table">
		<!-- search_table start -->
		<form id="searchForm" action="" method="post">
      <input type="hidden" id="year" name="year"/>
      <input type="hidden" id="month" name="month"/>
			<table class="type1">
				<!-- table start -->
				<caption>search table</caption>
				<colgroup>
					<col style="width: 110px" />
					<col style="width: *" />			
				</colgroup>
				<tbody>
					<tr>
                        <th scope="row"><spring:message code='commission.text.search.monthYear'/></th>
                        <td><input type="text" id="searchDt" name="searchDt" title="Month/Year" class="j_date2" value="${searchDt }" style="width: 200px;" /></td>						
					</tr>
				</tbody>
			</table>
			<!-- table end -->
		</form>
	</section>
	<!-- search_table end -->

	<section class="search_result">
	   <form id="callForm" action="" method="post">
	       <input type="hidden" name="procedureNm" id="procedureNm"/>
			<!-- search_result start -->
			<ul class="right_btns">
                <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
					<li><p class="btn_grid">
		                    <a href="#" id="addRow"><spring:message code='sys.btn.add'/></a>
		                </p></li>
		           <li><p class="btn_grid">
	                    <a href="#" id="save"><spring:message code='sys.btn.save'/></a>
	                </p></li>         
                </c:if> 
			</ul>
	
			<article class="grid_wrap">
				<!-- grid_wrap start -->
				<div id="grid_wrap" style="width: 100%; height: 500px; margin: 0 auto;"></div>
			</article>
			<!-- grid_wrap end -->
        </form>
	</section>
	<!-- bottom_msg_box end -->
	<!-- search_result end -->

</section>
<!-- content end -->

<!-- container end -->
<hr />

<!-- wrap end -->
</body>
</html>



