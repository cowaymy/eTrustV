<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">
var myGridID4;

var oArea = '<spring:message code="sys.area" />';
var oCity = '<spring:message code="sys.city" />';
var oState = '<spring:message code="sys.state" />';
var oPostcode = '<spring:message code="sys.title.postcode" />';
var oCountry = '<spring:message code="sys.country" />';
var oCountrycode = '<spring:message code="sys.title.countrycode" />';


var columnLayout4=[             
 {dataField:"areaId", headerText:'<spring:message code="sys.areaId" />', width: 110},
 {dataField:"area", headerText:'<spring:message code="sys.area" />', width: 180},
 {dataField:"postcode", headerText:'<spring:message code="sys.title.postcode" />', width: 85},
 {dataField:"city", headerText:'<spring:message code="sys.city" />', width: 85},
 {dataField:"state", headerText:'<spring:message code="sys.state" />', width: 85},
 {dataField:"country", headerText:'<spring:message code="sys.country" />', width: 85},
 {dataField:"countrycode", headerText:'<spring:message code="sys.title.countrycode" />', width: 100},
 {dataField:"statusId", headerText:'<spring:message code="sys.status" />', width: 85, editable : false},
 {dataField:"id", headerText:'<spring:message code="sys.source" />', editable : false},
];

$(document).ready(function(){
      
      var item = { "areaId" :  "xx-xxxx", "area" : "", "postcode" :  "", "city" :  "", "state" :  "", "country" :  "", "countrycode" :  "", "statusId" :  "Active", "id" :  "Internal"}; //row 추가

      myGridID4 = GridCommon.createAUIGrid("grid_wrap4", columnLayout4,null,"");  
      
      AUIGrid.addRow(myGridID4, item, "last"); //row 추가
      
      //아이템 grid 행 추가
      $("#addRow_other").click(function() { 

          AUIGrid.addRow(myGridID4, item, "last");

      });
      
      //save
      $("#save_other").click(function() {
          if (validation_other()) {
              Common.confirm("<spring:message code='sys.common.alert.save'/>",fn_saveGridData_other);
           }
      }); 

}); //Ready


function fn_saveGridData_other(){
    Common.ajax("POST", "/common/saveOtherAddressMaster.do", GridCommon.getEditData(myGridID4), function(result) {
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
function validation_other() {
    var result = true;
    var addList = AUIGrid.getAddedRowItems(myGridID4);

    if (addList.length == 0) {
      Common.alert("<spring:message code='sys.common.alert.noChange'/>");
      return false;
    }
    
    if(!validationCom_other(addList)){
        return false;
   }      
    
    return result;
}  


function validationCom_other(list){
    var result = true;

    //var lengthPostcode = postcode.length;
    
    for (var i = 0; i < list.length; i++) {
           var area = list[i].area;
           var postcode = list[i].postcode;
           var city = list[i].city;
           var state = list[i].state;
           var country = list[i].country;
           var countrycode = list[i].countrycode;
           
           var lengthPostcode = postcode.length;
           var lengthCountrycode = countrycode.length;
           
           if (area == "") {
        	   result = false;
        	   Common.alert("<spring:message code='sys.common.alert.validation' arguments='"+ oArea +"' htmlEscape='false'/>");
        	   break;
           } else if(postcode == ""){
        	   result = false;
               Common.alert("<spring:message code='sys.common.alert.validation' arguments='"+ oPostcode +"' htmlEscape='false'/>");
               break;
           } else if(city == ""){
               result = false;
               Common.alert("<spring:message code='sys.common.alert.validation' arguments='"+ oCity +"' htmlEscape='false'/>");
               break;
           } else if(state == ""){
               result = false;
               Common.alert("<spring:message code='sys.common.alert.validation' arguments='"+ oState +"' htmlEscape='false'/>");
               break;
           } else if(country == ""){
               result = false;
               Common.alert("<spring:message code='sys.common.alert.validation' arguments='"+ oCountry +"' htmlEscape='false'/>");
               break;
           } else if(countrycode == ""){
               result = false;
               Common.alert("<spring:message code='sys.common.alert.validation' arguments='"+ oCountrycode +"' htmlEscape='false'/>");
               break;
           } else if(lengthPostcode != 5){
        	   result = false;
        	   Common.alert("<spring:message code='sys.msg.limitCharacter' arguments='" + oPostcode +" ; 5' htmlEscape='false' argumentSeparator=';' />");
               break;
           } else if(lengthCountrycode != 2){
               result = false;
               Common.alert("<spring:message code='sys.msg.limitCharacter' arguments='" + oCountrycode +" ; 2' htmlEscape='false' argumentSeparator=';' />");
               break;
           }
    }
    
    return result;
}

function removeRowDetail_other() 
{
    AUIGrid.removeRow(myGridID4, "selectedIndex");
}

</script>   

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code='sys.title.NewAddressOther'/></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code='sys.btn.close'/></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#" id="addRow_other"><spring:message code='sys.btn.add'/></a></p></li>
    <li><p class="btn_grid"><a href="#" onclick="removeRowDetail_other();"><spring:message code='sys.btn.del'/></a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_wrap4" style="width:100%; height:380px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" id="save_other"><spring:message code='sys.btn.save'/></a></p></li>
</ul>


</section><!-- pop_body end -->

</div><!-- popup_wrap end -->