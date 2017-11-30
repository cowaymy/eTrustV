<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">
var myGridID3;
var mArea = '<spring:message code="sys.area" />';
var mCity = '<spring:message code="sys.city" />';
var mState = '<spring:message code="sys.state" />';
var mPostcode = '<spring:message code="sys.title.postcode" />';


var columnLayout3=[             
 {dataField:"areaId", headerText:'<spring:message code="sys.areaId" />', width: 120, editable : false},
 {dataField:"area", headerText:'<spring:message code="sys.area" />', width: 200, editable : true},
 {dataField:"postcode", headerText:'<spring:message code="sys.title.postcode" />', width: 100, editable : false },
 {dataField:"city", headerText:'<spring:message code="sys.city" />', width: 100 , editable : true },
 {dataField:"state", headerText:'<spring:message code="sys.state" />', width: 100, editable : true },
 {dataField:"country", headerText:'<spring:message code="sys.country" />', width: 100, editable : false },
 {dataField:"statusId", headerText:'<spring:message code="sys.status" />', width: 100, editable : false},
 {dataField:"id", headerText:'<spring:message code="sys.source" />', editable : false},
];

$(document).ready(function(){

      myGridID3 = GridCommon.createAUIGrid("grid_wrap3", columnLayout3,null,"");  
       
      //아이템 grid 행 추가
      $("#addRow_my").click(function() { 
    	  if (validation_postC()) {

	    	  var postcode_my = $("#postcode_my").val();
	          var item = { "areaId" :  "xxxx-xxxx", "area" : "", "postcode" : postcode_my, "city" :  "", "state" :  "", "country" :  "Malaysia", "statusId" :  "Active", "id" :  "Internal"}; //row 추가
	
	          AUIGrid.addRow(myGridID3, item, "last");
    	  }
      });
      
      //confirm
      $("#confirm_my").click(function() { 
    	  if (validation_postC()) {
    		  
    		  Common.ajax("GET", "/common/selectMyPostcode", $("#listSForm_my").serialize(), function(result) {
                  console.log("성공.");
                  console.log("data : " + result);
                   

                  if(result.length==0){
                	  Common.alert("<spring:message code='sys.msg.postcodeNExist'/>");
                  } else {
                	  Common.alert("<spring:message code='sys.msg.postcodeExist'/>");
                  }
               
              });

    	  }
      });
      
    //save
      $("#save_my").click(function() {
          if (validation_my()) {
              Common.confirm("<spring:message code='sys.common.alert.save'/>",fn_saveGridData_my);
           }
      }); 

      
}); //Ready


function fn_saveGridData_my(){
    Common.ajax("POST", "/common/saveMyAddressMaster.do", GridCommon.getEditData(myGridID3), function(result) {
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

/*  validation */
function validation_my() {
    var result = true;
    var addList = AUIGrid.getAddedRowItems(myGridID3);

    if (addList.length == 0) {
      Common.alert("<spring:message code='sys.common.alert.noChange'/>");
      return false;
    }
    
    if(!validationCom_my(addList)){
        return false;
   }      
    
    return result;
}  


function validationCom_my(list){
    var result = true;
    
    for (var i = 0; i < list.length; i++) {
           var area = list[i].area;
           var city = list[i].city;
           var state = list[i].state;
           
           if (area == "") {
               result = false;
               Common.alert("<spring:message code='sys.common.alert.validation' arguments='"+ mArea + "' htmlEscape='false'/>");
               break;
           } else if(city == ""){
               result = false;
               Common.alert("<spring:message code='sys.common.alert.validation' arguments='"+ mCity + "' htmlEscape='false'/>");
               break;
           } else if(state == ""){
               result = false;
               Common.alert("<spring:message code='sys.common.alert.validation' arguments='"+ mState + "' htmlEscape='false'/>");
               break;
           }
    }
    
    return result;
}

/*  validation */
function validation_postC() {
    var result = true;

    if(!validationCom_postC()){
        return false;
   }      
    
    return result;
}  


function validationCom_postC(){
    var result = true;

    var postcode_val = $("#postcode_my").val();
    var lengthPostcode = postcode_val.length;
           
    if (postcode_val == "") {
    	result = false;
    	Common.alert("<spring:message code='sys.common.alert.validation' arguments='"+ mPostcode + "' htmlEscape='false'/>");
    } else if(lengthPostcode != 5){
        result = false;
        Common.alert("<spring:message code='sys.msg.limitCharacter' arguments='" + mPostcode +" ; 5' htmlEscape='false' argumentSeparator=';' />");
    }
    return result;
}

//행 삭제
function delRow_my() {
    var rowPos = "selectedIndex"; //'selectedIndex'은 선택행 또는 rowposition : ex) 5
    AUIGrid.removeRow(myGridID3, "selectedIndex");
};




</script>   


<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code='sys.title.NewAddressMy'/></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code='sys.btn.close'/></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<form action="#" method="post" id="listSForm_my" name="listSForm_my">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sys.country" /><span class="must">*</span></th>
    <td>
    <input type="text" title="" placeholder="Country" class="w100p" value ="MY" disabled/>
    </td>
    <th scope="row"><spring:message code='sys.postcode'/><span class="must">*</span></th>
    <td><input type="text"  id="postcode_my" name="postcode_my" title="" placeholder="Post Code" class="" /><p class="btn_sky"><a href="#" id="confirm_my"><spring:message code="sys.btn.confirm" /></a></p></td>
</tr>
</tbody>
</table><!-- table end -->
</form>

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#" id="addRow_my"><spring:message code='sys.btn.add'/></a></p></li>
    <li><p class="btn_grid"><a href="#" onclick="delRow_my()"><spring:message code='sys.btn.del'/></a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_wrap3" style="width:100%; height:380px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" id="save_my"><spring:message code='sys.btn.save'/></a></p></li>
</ul>


</section><!-- pop_body end -->

</div><!-- popup_wrap end -->