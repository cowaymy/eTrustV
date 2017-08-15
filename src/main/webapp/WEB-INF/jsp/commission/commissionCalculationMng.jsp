<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<style type="text/css">

/* 커스텀 칼럼 스타일 정의 */
.my-column {
	text-align: left;
	margin-top: -20px;
}
</style>

<script type="text/javaScript">
	$(function() {
		//doGetCombo('/common/selectCodeList.do', '11', '','cmbCategory', 'S' , 'f_multiCombo'); //Single COMBO => Choose One
		//doGetCombo('/common/selectCodeList.do', '11', '','cmbCategory', 'A' , 'f_multiCombo'); //Single COMBO => ALL
		//doGetCombo('/common/selectCodeList.do', '11', '','cmbCategory', 'M' , 'f_multiCombo'); //Multi COMBO
		// f_multiCombo 함수 호출이 되어야만 multi combo 화면이 안깨짐.
		// doGetCombo('/common/selectCodeList.do', '11', '','cmbCategory', 'S' , 'fn_multiCombo'); 
	});

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
	var orgList = new Array(); //그룹 리스트
	var orgGridCdList = new Array(); //그리드 등록 그룹 리스트
	var orgItemList = new Array();   //그리드 등록 아이템 리스트

	//Start AUIGrid
	$(document).ready(function() {
		  
		//change orgCombo List
		$("#orgRgCombo").change(function() {
			$("#orgCombo").find('option').each(function() {
				$(this).remove();
			});
			if ($(this).val().trim() == "") {
				return;
			}		
			fn_getOrgCdListAllAjax(); //call orgList
			$("#ItemOrgCd").val("");
		});		
		$("#orgCombo").click(function(){
			$("#ItemOrgCd").val($(this).find("option[value='" + $(this).val() + "']").text());
		});
		
		// AUIGrid 그리드를 생성합니다.
		var options = {
            // 체크박스 표시 설정
			showRowCheckColumn : true,
            showRowAllCheckBox : false
        };
		myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,"itemSeq",options);

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
			Common.ajax("GET", "/commission/calculation/selectOrgProList", $("#searchForm").serialize(), function(result) {
				console.log("성공.");
				console.log("data : " + result);
				AUIGrid.setGridData(myGridID, result);
			});
	   });
	});//Ready
	
	//get Ajax data and set organization combo data
    function fn_getOrgCdListAllAjax(callBack) {
        Common.ajaxSync("GET", "/commission/calculation/selectOrgCdListAll", $("#searchForm").serialize(), function(result) {
            orgList = new Array();
            if (result) {
            	$("#orgCombo").append("<option value='' ></option>");
            	$("#orgCombo").append("<option value='' >BSD</option>");
                for (var i = 0; i < result.length; i++) {
                    $("#orgCombo").append("<option value='"+result[i].orgCd + "' > " + result[i].orgNm + "</option>");
                }
            }
            //if you need callBack Function , you can use that function
            if (callBack) {
                callBack(orgList);
            }
        });
    }

	//event management
	function auiCellEditingHandler(event) {
		if (event.type == "cellEditEnd") {
			
		} else if (event.type == "cellEditBegin") {
			
		}
	}
	// 행 추가 이벤트 핸들러
    function auiAddRowHandler(event) {
	}
    // 행 삭제 이벤트 핸들러
    function auiRemoveRowHandler(event) {
    }

	//그리드 그룹 리스트
	function getOrgCdData(val) {
		var retStr = "";
		$.each(orgGridCdList, function(key, value) {
			var id = value.id;
			if (id == val) {
				retStr = value.orgSeq + "," + value.orgGrCd + "," + value.id + "," + value.value + "," + value.cdDs;
			}
		});
		return retStr;
	}

	// 아이템 AUIGrid 칼럼 설정
	var columnLayout = [ {
		dataField : "orgNm",
		headerText : "ORG NAME",
		style : "my-column",
		editable : false,
		width : "20%"
	}, {
		dataField : "codeName",
        headerText : "Procedure Name",
        style : "my-column",
        editable : false,
        width : "20%"
	}, {
		dataField : "cdDs",
        headerText : "Description",
        style : "my-column",
        editable : false
	}, {
		dataField : "exBtn",
        headerText : "Execute",
        style : "my-column",
        renderer : {
            type : "ButtonRenderer",
            labelText : "EXECUTE",
            onclick : function(rowIndex, columnIndex, value, item) {
            	$("#procedureNm").val(AUIGrid.getCellValue(myGridID, rowIndex, 1));
            	Common.ajax("GET", "/commission/calculation/callCommissionProcedure", $("#callForm").serialize(), function(result) {
                }); 
            }
        },
        editable : false,
        width : 150
	}, {
		dataField : "codeId",
        headerText : "CODE ID",
        visible : false
	},  {
        dataField : "code",
        headerText : "CODE",
        visible : false
    }];

    //Make useYn ComboList
    function getUseYnComboList() {
        var list = [ "Y", "N" ];
        return list;
    }
    
    // Rule Book Mgmt grid 체크된 아이템 얻기
    function getCheckedRowItems() {
        var checkedItems = AUIGrid.getCheckedRowItems(myGridID2);
        var str = "";
        var rowItem;
        var len = checkedItems.length;

        if (len <= 0) {
            Common.alert("<spring:message code='commission.alert.noCheckbox'/>");
            return;
        }

        for (var i = 0; i < len; i++) {
            rowItem = checkedItems[i];
            str += "row : " + rowItem.rowIndex + ", id :" + rowItem.item.id + ", name : " + rowItem.item.name + "\n";
        }
        //alert(str);
    }
    
</script>


<section id="content">
	<!-- content start -->
	<ul class="path">
		<li><img src="image/path_home.gif" alt="Home" /></li>
		<li>Sales</li>
		<li>Order list</li>
	</ul>

	<aside class="title_line">
		<!-- title_line start -->
		<p class="fav">
			<a href="#" class="click_add_on">My menu</a>
		</p>
		<h2>RUN Commission</h2>

		<ul class="right_btns">
			<li><p class="btn_gray">			
					<a href="#"  id="search" ><span class="search"></span><spring:message code='sys.btn.search'/></a>
				</p></li>
		</ul>

	</aside>
	<!-- title_line end -->

	<section class="search_table">
		<!-- search_table start -->
		<form id="searchForm" action="" method="post">
      <input type="hidden" id="ItemOrgCd" name="ItemOrgCd"/>
			<table class="type1">
				<!-- table start -->
				<caption>search table</caption>
				<colgroup>
					<col style="width: 110px" />
					<col style="width: *" />
					<col style="width: 110px" />
					<col style="width: *" />
					<col style="width: 110px" />
					<col style="width: *" />
					<col style="width: 110px" />
					<col style="width: *" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">ORG Group</th>
						<td><select id="orgRgCombo" name="orgRgCombo" style="width: 100px;">
								<option value=""></option>
								<c:forEach var="list" items="${orgGrList }">
									<option value="${list.orgGrCd}">${list.orgGrNm}</option>
								</c:forEach>
						</select></td>
						<th scope="row">ORG Code</th>
						<td><select id="orgCombo" name="orgCombo" style="width: 100px;">
								<option value=""></option>
								<c:forEach var="list" items="${orgList }">
									<option value="${list.orgCd}">${list.orgNm}</option>
								</c:forEach>
						</select></td>					
						<input type="hidden" id="orgGrCd" name="orgGrCd" value="">
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
				<li><p class="btn_grid">
	                    <a href="#" id="execute">execute</a>
	                </p></li>
			</ul>
	
			<article class="grid_wrap">
				<!-- grid_wrap start -->
				<div id="grid_wrap" style="width: 100%; height: 500px; margin: 0 auto;"></div>
			</article>
			<!-- grid_wrap end -->
        </form>
	</section>
	<aside class="bottom_msg_box">
		<!-- bottom_msg_box start -->
		<p></p>
	</aside>
	<!-- bottom_msg_box end -->
	<!-- search_result end -->

</section>
<!-- content end -->

</section>
<!-- container end -->
<hr />

</div>
<!-- wrap end -->
</body>
</html>



