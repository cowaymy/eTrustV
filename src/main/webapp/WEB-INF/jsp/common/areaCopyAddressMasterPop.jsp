<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">
var myGridID2;

var cArea = '<spring:message code="sys.area" />';

//Grid에서 선택된 RowID
var selectedGridValue;

var columnLayout2=[             
 {dataField:"areaId", headerText:'<spring:message code="sys.areaId" />', width: 120, editable : false},
 {dataField:"area", headerText:'<spring:message code="sys.area" />', width: 200, editable : true},
 {dataField:"postcode", headerText:'<spring:message code="sys.title.postcode" />', width: 100, editable : false },
 {dataField:"city", headerText:'<spring:message code="sys.city" />', width: 100 , editable : false },
 {dataField:"state", headerText:'<spring:message code="sys.state" />', width: 100, editable : false },
 {dataField:"country", headerText:'<spring:message code="sys.country" />', width: 100, editable : false },
 {dataField:"statusId", headerText:'<spring:message code="sys.status" />', width: 100, editable : false},
 {dataField:"id", headerText:'<spring:message code="sys.source" />', editable : false},
 {dataField:"key", headerText:"key", editable : false}
];

$(document).ready(function(){
	  
	  var item = { "areaId" :  "${popPostcode}-xxxx", "area" : "", "postcode" :  "${popPostcode}", "city" :  "${popCity}", "state" :  "${popState}", "country" :  "${popCountry}", "statusId" :  "${popStatusId}", "id" :  "${popId}", "key" :  "${popAreaId}"}; //row 추가
	  var item_other = { "areaId" :  ("${popAreaId}").substring(0,2)+"-xxxx", "area" : "", "postcode" :  "${popPostcode}", "city" :  "${popCity}", "state" :  "${popState}", "country" :  "${popCountry}", "statusId" :  "${popStatusId}", "id" :  "${popId}", "key" :  "${popAreaId}"}; //row 추가
      
	  
      myGridID2 = GridCommon.createAUIGrid("grid_wrap2", columnLayout2,null,"");  
	  
      AUIGrid.hideColumnByDataField(myGridID2, "key");
      if (("${popAreaId}").length == 10){
    	  AUIGrid.addRow(myGridID2, item, "last"); //row 추가
      } else {
          AUIGrid.addRow(myGridID2, item_other, "last"); //row 추가
      }
      
       
      //아이템 grid 행 추가
      $("#addRow").click(function() { 

    	  if (("${popAreaId}").length == 10){
              AUIGrid.addRow(myGridID2, item, "last"); //row 추가
          } else {
        	  AUIGrid.addRow(myGridID2, item_other, "last"); //row 추가
          }

      });
      
      //save
      $("#save_copy").click(function() {
          if (validation_copy()) {
        	  if (("${popAreaId}").length == 10){
        		  Common.confirm("<spring:message code='sys.common.alert.save'/>",fn_saveGridData_copy);
              } else {
            	  Common.confirm("<spring:message code='sys.common.alert.save'/>",fn_saveGridData_copyOther);
              }
           }
      }); 

}); //Ready

function fn_saveGridData_copy(){
    Common.ajax("POST", "/common/saveCopyAddressMaster.do", GridCommon.getEditData(myGridID2), function(result) {
        // 공통 메세지 영역에 메세지 표시.
        Common.setMsg("<spring:message code='sys.msg.success'/>");
        $("#search").trigger("click");
        Common.alert("<spring:message code='sys.msg.success'/>");
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

function fn_saveGridData_copyOther(){
    Common.ajax("POST", "/common/saveCopyOtherAddressMaster.do", GridCommon.getEditData(myGridID2), function(result) {
        // 공통 메세지 영역에 메세지 표시.
        Common.setMsg("<spring:message code='sys.msg.success'/>");
        $("#search").trigger("click");
        Common.alert("<spring:message code='sys.msg.success'/>");
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

/*  validation */
function validation_copy() {
    var result = true;
    var addList = AUIGrid.getAddedRowItems(myGridID2);

    if (addList.length == 0) {
      Common.alert("<spring:message code='sys.common.alert.noChange'/>");
      return false;
    }
    
    if(!validationCom_copy(addList)){
        return false;
   }      
    
    return result;
}  


function validationCom_copy(list){
    var result = true;
    for (var i = 0; i < list.length; i++) {
           var area = list[i].area;
           if (area == "") {
             result = false;
             Common.alert("<spring:message code='sys.common.alert.validation' arguments='" + cArea + "' htmlEscape='false'/>");
             break;
           }
    }
    return result;
}


function removeRowDetail() 
{
	AUIGrid.removeRow(myGridID2, "selectedIndex");
}
</script>   


<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code='sys.title.copyAddressMaster'/></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code='sys.btn.close'/></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->


<form action="#" method="post" id="editForm" name="editForm">
    <input type="hidden" id = "pAreaId" name="pAreaId" />
    <input type="hidden" id = "pArea" name="pArea" />
    <input type="hidden" id = "pPostcode" name="pPostcode" />
    <input type="hidden" id = "pCity" name="pCity" />
    <input type="hidden" id = "pCountry" name="pCountry" />
    <input type="hidden" id = "pStatusId" name="pStatusId" />
    <input type="hidden" id = "pId" name="pId" />
</form>   
<ul class="right_btns">
    <li><p class="btn_grid"><a href="#" id="addRow"><spring:message code='sys.btn.add'/></a></p></li>
    <li><p class="btn_grid"><a href="#" onclick="removeRowDetail();"><spring:message code='sys.btn.del'/></a></p></li>
</ul>

<article id="aa" class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_wrap2" style="width:100%; height:380px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" id="save_copy"><spring:message code='sys.btn.save'/></a></p></li>
</ul>


</section><!-- pop_body end -->

</div><!-- popup_wrap end -->

</div><!-- popup_wrap end -->