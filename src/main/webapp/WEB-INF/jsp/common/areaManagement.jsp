<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">

    // Make AUIGrid 
    var myGridID;
    
    var aPostCode = "<spring:message code='sys.title.postcode' />";
    var aCountry = "<spring:message code='sys.country' />";

    //Start AUIGrid
    $(document).ready(function() {
        
        // Create AUIGrid
        myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, "");
        
       //Rule Book Item search
        $("#search").click(function(){  
        	if (validation()) {
	            Common.ajax("GET", "/common/selectAreaManagement", $("#listSForm").serialize(), function(result) {
	                console.log("성공.");
	                console.log("data : " + result);
	                AUIGrid.setGridData(myGridID, result);
	            });
        	} //validation
       }); 
       
      //save
        $("#save").click(function() {
              Common.confirm("<spring:message code='sys.common.alert.save'/>",fn_saveGridData);
       }); 
      
        //excel Download
        $('#excelDown').click(function() {        
           GridCommon.exportTo("grid_wrap", 'xlsx', "Area Management");
        });
        
    });//Ready
    
    //Copy Pop 호출
    function fn_areaCopy(){

        var selectedItems = AUIGrid.getSelectedItems(myGridID);
        if(selectedItems.length <= 0) {
            Common.alert("<spring:message code='expense.msg.NoData'/> ");
            return;
        }
        // singleRow, singleCell 이 아닌 multiple 인 경우 선택된 개수 만큼 배열의 요소가 있음
        var first = selectedItems[0];

        $("#popAreaId").val(AUIGrid.getCellValue(myGridID , first.rowIndex , "areaId"));
        $("#popArea").val(AUIGrid.getCellValue(myGridID , first.rowIndex , "area"));
        $("#popPostcode").val(AUIGrid.getCellValue(myGridID , first.rowIndex , "postcode"));
        $("#popCity").val(AUIGrid.getCellValue(myGridID , first.rowIndex , "city"));
        $("#popState").val(AUIGrid.getCellValue(myGridID , first.rowIndex , "state"));
        $("#popCountry").val(AUIGrid.getCellValue(myGridID , first.rowIndex , "country"));
        $("#popStatusId").val(AUIGrid.getCellValue(myGridID , first.rowIndex , "statusId"));
        $("#popId").val(AUIGrid.getCellValue(myGridID , first.rowIndex , "id"));
        
        //alert(AUIGrid.getCellValue(myGridID , first.rowIndex , "areaId"));

       Common.popupDiv("/common/areaCopyAddressMasterPop.do", $("#popSForm").serializeJSON(), null, true, "areaCopyAddressMasterPop");
    } 
    
    
    function fn_saveGridData(){
        Common.ajax("POST", "/common/saveAreaManagement.do", GridCommon.getEditData(myGridID), function(result) {
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
    
    
    // AUIGrid 칼럼 설정
    var columnLayout = [{
        dataField : "areaId",
        headerText : '<spring:message code="sys.areaId" />',
        width : 120,
        editable : false
        
    },{
        dataField : "area",
        headerText : '<spring:message code="sys.area" />',
        width : 170,
        editable : false
    },{
        dataField : "postcode",
        headerText : '<spring:message code="sys.title.postcode" />', 
        width : 100,
        editable : false
    },{
        dataField : "city",
        headerText : '<spring:message code="sys.city" />',
        width : 100,
        editable : false
    }, {
        dataField : "state",
        headerText : '<spring:message code="sys.state" />',
        width : 100,
        editable : false
    },{
        dataField : "country",
        headerText : '<spring:message code="sys.country" />', 
        width : 80,
        editable : false
    },{
        dataField : "statusId",
        headerText : '<spring:message code="sys.status" />',
        editRenderer : {
            type : "DropDownListRenderer",
            list : ["Active", "Inactive"]
        },
        width : 100
    },{
        dataField : "gstChk",
        headerText : '<spring:message code="sys.gst" />',
        editRenderer : {
            type : "DropDownListRenderer",
            list : ["Exclude GST", "Include GST"]
       },
       width : 100
    },{
        dataField : "id",
        headerText : '<spring:message code="sys.source" />',
        editable : false
    }];

    
    /*  validation */
    function validation() {
        var result = true;

        if(!validationCom() || !validationCom()){
            return false;
       }      
        return result;
    }
    
    function validationCom(){
        var result = true;
        var country = $("#country").val();
        var postcode = $("#postcode").val();

        if(country == '' || postcode == ''){
        	result = false;
	        if (country == '') {
	        	Common.alert("<spring:message code='sys.common.alert.validation' arguments='" + aCountry + "' htmlEscape='false'/>");
	        } else if (postcode == '') {
	        	Common.alert("<spring:message code='sys.common.alert.validation' arguments='" + aPostCode + "' htmlEscape='false'/>");
	        }
        }
        
        var lengthPostcode = postcode.length;

        if(lengthPostcode != 5){
        	result = false;
        	//Common.alert("Please enter Postcode within 5 characters.");
        	Common.alert("<spring:message code='sys.msg.limitCharacter' arguments='" + aPostCode +" ; 5' htmlEscape='false' argumentSeparator=';' />");
        }
        return result;
    }
    
    //New MY Pop 호출
    function fn_areaNewMy(){

        Common.popupDiv("/common/areaNewAddressMyPop.do", $("#popSForm").serializeJSON(), null, true, "areaNewAddressMyPop");
    } 
    
    //New Other Pop 호출
    function fn_areaNewOther(){
        
        Common.popupDiv("/common/areaNewAddressOtherPop.do", $("#popSForm").serializeJSON(), null, true, "areaNewAddressOtherPop");
    } 
    
</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home"/></li>
    <li>System</li>
    <li>Area Management</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2><spring:message code='sys.AreaManagement'/></h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a href="#"  id="search" ><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#"  id="popSForm" name="popSForm" method="post">
<input type="hidden" id="popAreaId" name="popAreaId"/>
<input type="hidden" id="popArea" name="popArea"/>
<input type="hidden" id="popPostcode" name="popPostcode"/>
<input type="hidden" id="popCity" name="popCity"/>
<input type="hidden" id="popState" name="popState"/>
<input type="hidden" id="popCountry" name="popCountry"/>
<input type="hidden" id="popStatusId" name="popStatusId"/>
<input type="hidden" id="popId" name="popId"/>
</form>

<form action="#" method="post"  id="listSForm" name="listSForm">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code='sys.country'/><span class="must">*</span></th>
    <td>
    <input type="text"  id="country" name="country" title="" placeholder="Country" class="w100p" value="MY"/>
    </td>
    <th scope="row"><spring:message code='sys.postcode'/><span class="must">*</span></th>
    <td>
    <input type="text"  id="postcode"  name="postcode" title="" placeholder="Post Name" class="w100p"/>
    </td>
    <th scope="row"><spring:message code='sys.areaname'/></th>
    <td>
    <input type="text" id="areaName" name="areaName" title="" placeholder="" class="w100p" />
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
</aside><!-- link_btns_wrap end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#" id="excelDown"><spring:message code='sys.dwAddressMaster'/></a></p></li>
    <li><p class="btn_grid"><a href="#" onClick="javascript:fn_areaCopy();"><spring:message code='sys.copy'/></a></p></li>
    <li><p class="btn_grid"><a href="#" onClick="javascript:fn_areaNewMy();"><spring:message code='sys.newMy'/></a></p></li>
    <li><p class="btn_grid"><a href="#" onClick="javascript:fn_areaNewOther();"><spring:message code='sys.newOther'/></a></p></li>
    <li><p class="btn_grid"><a href="#" id="save"><spring:message code='sys.btn.save'/></a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_wrap" style="width:100%; height:380px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->
