<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">

    //AUIGrid 생성 후 반환 ID
	var inchargeGridID;
	
	$(document).ready(function(){
	    
	    
	    // AUIGrid 그리드를 생성합니다.
	    createInchargeGrid();
	    
	    fn_getInchargeAjax();
	    
	});
	
	function createInchargeGrid() {
        // AUIGrid 칼럼 설정
        
        // 데이터 형태는 다음과 같은 형태임,
        //[{"id":"#Cust0","date":"2014-09-03","name":"Han","country":"USA","product":"Apple","color":"Red","price":746400}, { .....} ];
        var inchargeColumnLayout = [{
                dataField : "userName",
                headerText : "Username",
                width : 160,
                editable : false
            }, {
                dataField : "userFullName",
                headerText : "Name",
                editable : false
            }];
       
        // 그리드 속성 설정
        var gridPros = {
            // 페이징 사용       
            usePaging : true,
            // 한 화면에 출력되는 행 개수 20(기본값:20)
            pageRowCount : 20,
            editable : true,
            fixedColumnCount : 1,
            showStateColumn : true, 
            displayTreeOpen : true,
            selectionMode : "multipleCells",
            headerHeight : 30,
            // 그룹핑 패널 사용
            useGroupingPanel : true,
            // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            skipReadonlyColumns : true,
            // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            wrapSelectionMove : true,
            // 줄번호 칼럼 렌더러 출력
            showRowNumColumn : true,
            groupingMessage : "Here groupping"
        };
        
        inchargeGridID = GridCommon.createAUIGrid("#incharge_grid_wrap", inchargeColumnLayout, gridPros);
    }
	
    function fn_getInchargeAjax(){
        Common.ajax("GET", "/sales/order/inchargePersonList.do",$("#getParamForm").serialize(), function(result) {
            AUIGrid.setGridData(inchargeGridID, result);
        });
    }
    
    function fn_inCharge(obj , value , tag , selvalue){
    	
        var robj= '#'+obj;
        $(robj).attr("disabled",false);
        if(value == 56){
            getCmbChargeNm('/sales/order/inchargeJsonList.do', '56' , value , selvalue,obj, 'S', '');
        }else if(value == 133){
            getCmbChargeNm('/sales/order/inchargeJsonList.do', '133' , value , selvalue,obj, 'S', '');
        }else{
             $("#inchargeNm").find("option").remove();
        }
    }
    
    function getCmbChargeNm(url, groupCd ,codevalue ,  selCode, obj , type, callbackFn){
        $.ajax({
            type : "GET",
            url : url,
            data : { roleId : groupCd},
            dataType : "json",
            contentType : "application/json;charset=UTF-8",
            success : function(data) {
               var rData = data;
               doDefNmCombo(rData, selCode, obj , type,  callbackFn)
            },
            error: function(jqXHR, textStatus, errorThrown){
                alert("Draw ComboBox['"+obj+"'] is failed. \n\n Please try again.");
            },
            complete: function(){
            }
        });
    }
    
    function doDefNmCombo(data, selCode, obj , type, callbackFn){
        var targetObj = document.getElementById(obj);
        var custom = "";

        for(var i=targetObj.length-1; i>=0; i--) {
            targetObj.remove( i );
        }
        obj= '#'+obj;

        $.each(data, function(index,value) {
            //CODEID , CODE , CODENAME ,,description
            if(selCode==data[index].userId){
                $('<option />', {value : data[index].userId, text:data[index].userFullNm}).appendTo(obj).attr("selected", "true");
            }else{
                $('<option />', {value : data[index].userId, text:data[index].userFullNm}).appendTo(obj);
            }
        });


        if(callbackFn){
            var strCallback = callbackFn+"()";
            eval(strCallback);
        }
    }
    
    function fn_saveReAssign(){
    	Common.ajax("GET", "/sales/order/saveReAssign.do", $("#getParamForm").serialize(), function(result){
            //result alert and reload
            Common.alert("New incharge person saved.", fn_success);
        }, function(jqXHR, textStatus, errorThrown) {
            try {
                console.log("status : " + jqXHR.status);
                console.log("code : " + jqXHR.responseJSON.code);
                console.log("message : " + jqXHR.responseJSON.message);
                console.log("detailMessage : " + jqXHR.responseJSON.detailMessage);
    
                //Common.alert("Failed to order invest reject.<br />"+"Error message : " + jqXHR.responseJSON.message + "</b>");
                Common.alert("Failed to save. Please try again later.");
                }
            catch (e) {
                console.log(e);
                alert("Failed to save. Please try again later.");
            }
            alert("Fail : " + jqXHR.responseJSON.message);
            });
    }
    
    function fn_success(){
    	fn_searchListAjax();
        
        $("#reAssignClose").click();
    }
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Suspend incharge person Maintenance</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="reAssignClose">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<form id="getParamForm" name="getParamForm" method="GET">
    <input type="hidden" id="susId" name="susId" value="${susId }">

	<table class="type1 mt10"><!-- table start -->
	<caption>table</caption>
	<colgroup>
	    <col style="width:180px" />
	    <col style="width:*" />
	</colgroup>
	<tbody>
		<tr>
		    <th scope="row">Current incharge person</th>
		    <td>
		    
		    <article class="grid_wrap" style="width:100%; height:200px;"><!-- grid_wrap start -->
		        <div id="incharge_grid_wrap" style="width:100%; height:200px; margin:0 auto;"></div>
		    </article><!-- grid_wrap end -->
		
		    </td>
		</tr>
		<tr>
		    <th scope="row">New incharge person</th>
		    <td>
		    <select  id="incharge" name="incharge" onchange="fn_inCharge('inchargeNm', this.value, '', '')">
		        <option value="">Incharge Person Type</option>
		        <option value="56">Credit Recovery Team</option>
		        <option value="133">Credit Recovery 3rd Party</option>
		    </select>
		    <select class="ml10" id="inchargeNm" name="inchargeNm">
		    </select>
		    </td>
		</tr>
	</tbody>
	</table><!-- table end -->
</form>

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onclick="fn_saveReAssign()">Save</a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
