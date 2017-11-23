<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>

<style type="text/css">

/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
}

/* 커스컴 disable 스타일*/
.mycustom-disable-color {
    color : #cccccc;
}

/* 그리드 오버 시 행 선택자 만들기 */
.aui-grid-body-panel table tr:hover {
    background:#D9E5FF;
    color:#000;
}
.aui-grid-main-panel .aui-grid-body-panel table tr td:hover {
    background:#D9E5FF;
    color:#000;
}

</style>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>
<script type="text/javaScript" language="javascript">

    // AUIGrid 생성 후 반환 ID
    var myGridID;
    
    var dialog;
    
    var itemdata;
    
    // V= 보기, U=수정, N=신규....  
    var div;
    
    var selectedItem; 
    
    // AUIGrid 칼럼 설정             // formatString : "mm/dd/yyyy",    dataType:"numeric", formatString : "#,##0"
     var columnLayout = [
                         {dataField:"courierid",headerText:"courierId",width:100,visible:false },
                         {dataField:"couriercd",headerText:"Code",width:"15%",visible:true },
                         {dataField:"couriernm",headerText:"Name",width:"30%",visible:true,style :"aui-grid-user-custom-left"},
                         {dataField:"regno",headerText:"Reg. No.",width:"15%",visible:true },
                         {dataField:"country",headerText:"Country",width:"10%",visible:true },
                         
                         {dataField:"countryid",headerText:"countryId",width:100,visible:false },
                         {dataField:"state",headerText:"State",width:"15%",visible:true },
                         {dataField:"stateid",headerText:"stateId",width:100,visible:false },
                         {dataField:"area",headerText:"Area",width:"15%",visible:true },
                         {dataField:"areaid",headerText:"areaId",width:100,visible:false },

                         {dataField:"postcd",headerText:"postCd",width:100,visible:false },
                         {dataField:"contactno1",headerText:"contactNo1",width:100,visible:false },
                         {dataField:"contactno2",headerText:"contactNo2",width:100,visible:false },
                         {dataField:"faxno",headerText:"faxNo",width:100,visible:false }
                         
                         ];
    
    
    var gridoptions = {showStateColumn : false , editable : false, pageRowCount : 30, usePaging : true, useGroupingPanel : false , fixedColumnCount:2};
    
    var pdata;

    $(document).ready(function(){
        // masterGrid 그리드를 생성합니다.
        myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,"", gridoptions);
        
        pdata = { groupCode : 'country' };
        
        doGetComboAddr('/common/selectAddrSelCodeList.do', pdata ,'this.value','srchCntry', 'S', '');
        
        AUIGrid.bind(myGridID, "cellClick", function( event ) 
        {   
        });

        // 셀 더블클릭 이벤트 바인딩
        AUIGrid.bind(myGridID, "cellDoubleClick", function(event) 
        {
             $("#view").click();
        });
        
        AUIGrid.bind(myGridID, "ready", function(event) {
        });
    });

    $(function(){
        $("#search").click(function(){
            searchAjax();
        });
        $("#clear").click(function(){
              $("#searchForm")[0].reset();
              doDefCombo('', '' ,'srchState', 'S', ''); 
              doDefCombo('', '' ,'srchArea', 'S', '');
              doDefCombo('', '' ,'srchPstCd', 'S', '');   

        });
        $("#view").click(function(){
        	div="V";
        	$("#detailHead").text("Courier Information Details");
        	selectedItem = AUIGrid.getSelectedIndex(myGridID);
            if (selectedItem[0] > -1){
	        	fn_openDetail(div,selectedItem[0]);
	        	$("#editWindow").show();
            }else{
            Common.alert('Choice Data please..');
            }
        });
        $("#update").click(function(){
            div="U";
            $("#detailHead").text("Courier Information Update");
            selectedItem = AUIGrid.getSelectedIndex(myGridID);
            if (selectedItem[0] > -1){
                fn_openDetail(div,selectedItem[0]);
                $("#editWindow").show();
            }else{
            Common.alert('Choice Data please..');
            }
       
        });
        $("#insert").click(function(){
                div="N";
                $("#detailHead").text("Courier Information New");
                fn_setVisiable(div);
                $("#editWindow").show();
        });
        $("#cancelPopbtn").click(function(){
        	$("#editWindow").hide();
        });
        $("#updatePopbtn").click(function(){
        	//$("#editWindow").hide();
        	   div="U";
        	   saveAjax(div);
        	   $("#editWindow").hide();
        	  
        });
        $("#savePopbtn").click(function(){
        	//$("#editWindow").hide();
        	   div="N";
        	   saveAjax(div);
        	   $("#editWindow").hide();
        	  
        });
        $(".numberAmt").keyup(function(e) {
            regex = /[^.0-9]/gi;
            v = $(this).val();
            if (regex.test(v)) {
                var nn = v.replace(regex, '');
                $(this).val(v.replace(regex, ''));
                $(this).focus();
                return;
            }
        });
       $("#curcntyid").change(function(){
           doDefCombo('', '' ,'curstateid', 'S', ''); 
           doDefCombo('', '' ,'curareaid', 'S', '');
           doDefCombo('', '' ,'curpostcod', 'S', '');   
         }); 
       $("#curstateid").change(function(){
           doDefCombo('', '' ,'curareaid', 'S', '');
           doDefCombo('', '' ,'curpostcod', 'S', '');   
         }); 
       $("#curareaid").change(function(){
           doDefCombo('', '' ,'curpostcod', 'S', '');   
         }); 
       
       $("#srchCntry").change(function(){
           doDefCombo('', '' ,'srchState', 'S', ''); 
           doDefCombo('', '' ,'srchArea', 'S', '');
           doDefCombo('', '' ,'srchPstCd', 'S', '');   
         }); 
       $("#srchState").change(function(){
           doDefCombo('', '' ,'srchArea', 'S', '');
           doDefCombo('', '' ,'srchPstCd', 'S', '');   
         }); 
       $("#srchArea").change(function(){
           doDefCombo('', '' ,'srchPstCd', 'S', '');   
         }); 
    });
    
    
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
    /* function Start*/
   function searchAjax() {
        
        var url = "/logistics/courier/selectCourierList.do";
        var param = $('#searchForm').serializeJSON();
        Common.ajax("POST" , url , param , function(data){
        
            AUIGrid.setGridData(myGridID, data.data);
        
        });
    }
    
   function saveAjax(div) {
	    var url;
	    var key;
	    var val= $("#detailForm").serializeJSON();
	    selectedItem = AUIGrid.getSelectedIndex(myGridID);
	   if(div=="U"){
		   url="/logistics/courier/motifyCourier.do";
	   }else if(div=="N"){
		   url="/logistics/courier/insertCourier.do";
	   }
	   Common.ajax("POST",url,val,function(result){
		   Common.alert(result.msg);
		   $("#search").trigger("click");
		   if(div=="U"){
			     $("#view").click();
		  }
	   });
   } 
   
    
    function fn_openDetail(div,idxId){
    	var id =AUIGrid.getCellValue(myGridID ,idxId, 'courierid');
    	Common.ajaxSync("GET", "/logistics/courier/selectCourierDetail",{"courierid":id} ,
                function(data){
                var setVal=data.result;
                
		    	if(div=="V"){
		    		fn_setValuePop(setVal);
		    		fn_setVisiable(div);
		    	}else if(div=="U"){
		    		fn_setValuePop(setVal);
		    		fn_setVisiable(div);
		    	}else if(div=="N"){
		    	}
        });
    }
    function fn_setValuePop(setVal){
    	$("#curcode").val(setVal[0].curierCode);
        $("#curname").val(setVal[0].curierName);
        $("#curregno").val(setVal[0].curierRegNo);
        pdata = { groupCode : 'country' };
        
        doGetComboAddr('/common/selectAddrSelCodeList.do', pdata , setVal[0].curierCntyId,'curcntyid', 'S', '');
        
        getAddrRelay2( 'curstateid' ,'detail', 'state' , setVal[0].curierStateId , setVal);
        getAddrRelay2( 'curareaid' ,'detail', 'area' , setVal[0].curierAreaId , setVal);
        getAddrRelay2( 'curpostcod' ,'detail', 'post' , setVal[0].curierPostCodeId , setVal);
        
        $("#curcntcno1").val(setVal[0].curierCntcNo1);
        $("#curcntcno2").val(setVal[0].curierCntcNo2);
        $("#curfaxno").val(setVal[0].curierFaxNo);
        $("#curemail").val(setVal[0].curierEmail);
        $("#curadd1").val(setVal[0].curierAdd1);
        $("#curadd2").val(setVal[0].curierAdd2);  
            
    }
    
    function fn_setVisiable(div){
    	if(div=="V"){
  		      $("#curcode").prop('readonly', true);
  		      $("#curname").prop('readonly', true);
  		      $("#curregno").prop('readonly', true);
  		      $("#curcntyid").prop('disabled', true);
  		      $("#curstateid").prop('disabled', true);
  		      $("#curareaid").prop('disabled', true);
  		      $("#curpostcod").prop('disabled', true);
  		      $("#curcntcno1").prop('readonly', true);
  		      $("#curcntcno2").prop('readonly', true);
  		      $("#curfaxno").prop('readonly', true);
  		      $("#curemail").prop('readonly', true);
  		      $("#curadd1").prop('readonly', true);
  		      $("#curadd2").prop('readonly', true);
  		      
              $("#savePopbtn").hide();
              $("#updatePopbtn").hide();
        }else if(div=="U"){
            $("#curcode").prop('readonly', true);
            $("#curname").prop('readonly', false);
            $("#curregno").prop('readonly', false);
            $("#curcntyid").prop('disabled', false);
            $("#curstateid").prop('disabled', false);
            $("#curareaid").prop('disabled', false);
            $("#curpostcod").prop('disabled', false);
            $("#curcntcno1").prop('readonly', false);
            $("#curcntcno2").prop('readonly', false);
            $("#curfaxno").prop('readonly', false);
            $("#curemail").prop('readonly', false);
            $("#curadd1").prop('readonly', false);
            $("#curadd2").prop('readonly', false);
            
            
            $("#updatePopbtn").show();
            $("#savePopbtn").hide();
        }else if(div=="N"){
        	$("#curcode").val("Auto-Generate");            
            $("#curname").val("");
            $("#curregno").val("");
            //$("#curcntyid").val("");
            //$("#curstateid").val("");
            //$("#curareaid").val("");
            //$("#curpostcod").val("");
            $("#curcntcno1").val("");
            $("#curcntcno2").val("");
            $("#curfaxno").val("");
            $("#curemail").val("");
            $("#curadd1").val("");
            $("#curadd2").val("");
                        
            $("#curname").prop('readonly', false);
            $("#curregno").prop('readonly', false);
            $("#curcntyid").prop('disabled', false);
            $("#curstateid").prop('disabled', false);
            $("#curareaid").prop('disabled', false);
            $("#curpostcod").prop('disabled', false);
            $("#curcntcno1").prop('readonly', false);
            $("#curcntcno2").prop('readonly', false);
            $("#curfaxno").prop('readonly', false);
            $("#curemail").prop('readonly', false);
            $("#curadd1").prop('readonly', false);
            $("#curadd2").prop('readonly', false);
            
            $("#savePopbtn").show();
            $("#updatePopbtn").hide();
            
        	combReset();
        }
    }
    
  function combReset(){
	  pdata = { groupCode : 'country' }; 
	  doGetComboAddr('/common/selectAddrSelCodeList.do', pdata , 'this.value','curcntyid', 'S', ''); 
      doDefCombo('', '' ,'curstateid', 'S', ''); 
      doDefCombo('', '' ,'curareaid', 'S', '');
      doDefCombo('', '' ,'curpostcod', 'S', '');   
	  
  }
  
  function getAddrRelay2(v1 , v2 , v3 , v4 , v5){
	  if (v2 == 'search'){
		  pdata = { groupCode : v3 , country:$("#srchCntry").val() , state:$("#srchState").val() , area:$("#srchArea").val()};
	  }else if(v2 == 'detail'){
		  if(v5 == undefined){
			  pdata = { groupCode : v3 , country:$("#curcntyid").val() , state:$("#curstateid").val() , area:$("#curareaid").val()};
		  }else{
			  if (v1 == 'state'){
				  pdata = { groupCode : v3, country:v5[0].curierCntyId };
			  }else if (v1 == 'area'){
				  pdata = { groupCode : v3, country:v5[0].curierCntyId , state:v5[0].curierStateId };
			  }else if (v1 == 'post'){
				  pdata = { groupCode : v3, country:v5[0].curierCntyId , state:v5[0].curierStateId , area:v5[0].curierAreaId};
			  }else{
				  pdata = { groupCode : v3 };
			  }
		  }  
	  }
      doGetComboAddr('/common/selectAddrSelCodeList.do', pdata ,v4,v1, 'S', '');
  }
 
</script>
<div id="SalesWorkDiv" class="SalesWorkDiv" style="width: 100%; height: 960px; position: static; zoom: 1;">
<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Courier</li>
    <li>Courier List</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Courier Search</h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a id="search"><span class="search"></span><spring:message code='sys.btn.search' /></a></p></li>
    <li><p class="btn_blue"><a id="clear"><span class="clear"></span><spring:message code='sys.btn.clear' /></a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form id="searchForm" name="searchForm">
<input type="hidden" id="sUrl" name="sUrl">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Courier Code</th>
    <td><input type="text" name="srchCourierCd" id="srchCourierCd" class="w100p" /></td>
    <th scope="row">Courier Name</th>
    <td><input type="text" name="srchCourierNm" id="srchCourierNm"  class="w100p"/></td>
    <th scope="row">Courier Registration No</th>
    <td><input type="text" name="srchRegNo" id="srchRegNo"  class="w100p"/></td>
    <th>Contact No</th>
    <td><input type="text" name="srchcontactNo" id="srchcontactNo"  class="w100p"/></td>
</tr>
<tr>
    <th>Country</th>
    <td><select id="srchCntry" name="srchCntry" class="w100p" onchange="getAddrRelay2('srchState' ,'search', 'state','')"></select></td>
    <th>State</th>
    <td><select  id="srchState" name="srchState" class="w100p" onchange="getAddrRelay2('srchArea'  ,'search', 'area' ,'')"><option>Choose One</option></select></td>
    <th>Area</th>
    <td><select  id="srchArea" name="srchArea"  class="w100p" onchange="getAddrRelay2('srchPstCd' ,'search', 'post' ,'')"><option>Choose One</option></select></td>
    <th>PostCode</th>
    <td><select  id="srchPstCd" name="srchPstCd" class="w100p"><option>Choose One</option></select></td>
</tr>
</tbody>
</table><!-- table end -->
</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">

    <li><p class="btn_grid"><a id="view"><spring:message code='sys.btn.view' /></a></p></li>
    <li><p class="btn_grid"><a id="update"><spring:message code='sys.btn.update' /></a></p></li>
    <li><p class="btn_grid"><a id="insert"><spring:message code='sys.btn.add' /></a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_wrap"></div>
</article><!-- grid_wrap end -->
                
<div class="popup_wrap" id="editWindow" style="display:none"><!-- popup_wrap start -->

<header class="pop_header" ><!-- pop_header start -->
					<h1 id="detailHead"></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul> 
</header><!-- pop_header end -->                
			<section class="pop_body">
				<!-- pop_body start -->
					<form id="detailForm" name="detailForm" method="POST">
						<table class="type1"><!-- table start -->
						<caption>search table</caption>
						<colgroup>
						   <col style="width:140px" />
						   <col style="width:*" />
						   <col style="width:150px" />
						   <col style="width:*" />
						   <col style="width:150px" />
						   <col style="width:*" />
						</colgroup>
						<tbody>
						<tr>
						    <th scope="row">Courier Code</th>
						    <td id="tdcurcode">
						    <input type="text" title="" placeholder=""  class="w100p" id="curcode" name="curcode"/>
						    </td>
						    <th scope="row">Courier Name</th>
						    <td id="tdcurname">
						    <input type="text" title="" placeholder="" class="w100p" id="curname" name="curname" />
						    </td>
						    <th scope="row">Courier Registration No</th>
						    <td id="tdcurregno">
						    <input type="text" title="" placeholder="" class="w100p"  id="curregno" name="curregno"/>
						    </td>
						</tr>
						<tr>
						    <th scope="row">Contact No. (1)</th>
						    <td  id="tdcurcntcno1">
						    <input type="text" title="" placeholder="" class="w100p" id="curcntcno1" name="curcntcno1" />
						    </td>
						    <th scope="row">Contact No. (2)</th>
						    <td id="tdcurcntcno2">
						    <input type="text" title="" placeholder="" class="w100p" id="curcntcno2" name="curcntcno2" />
						    </td>
						    <th scope="row">Country</th>
						    <td id="tdcurcntyid">
						    <select class="w100p" id="curcntyid" name="curcntyid" onchange="getAddrRelay2('curstateid' , 'detail', 'state','')">
						    </select>
						    </td>
						</tr>
						<tr>
						    <th scope="row">Fax No.</th>
						    <td id="tdcurfaxno" >
						    <input type="text" title="" placeholder="" class="w100p"  id="curfaxno" name="curfaxno"/>
						    </td>
						    <th scope="row">Email</th>
						    <td  id="tdcuremail">
						    <input type="text" title="" placeholder="" class="w100p"  id="curemail" name="curemail"/>
						    </td>
						    <th scope="row">State</th>
						    <td id="tdcurstateid">
						    <select class="w100p" id="curstateid" name="curstateid" onchange="getAddrRelay2('curareaid' , 'detail' , 'area', this.value)" >
						    </select>
						    </td>
						</tr>
						<tr>
						    <th scope="row" rowspan="3" >Address</th>
						    <td colspan="3" id="tdcuradd1">
						    <input type="text" title="" placeholder="" class="w100p" id="curadd1" name="curadd1"/>
						    </td>
						    <th scope="row">Area</th>
						    <td  id="tdcurareaid" >
						    <select class="w100p" id="curareaid" name="curareaid" onchange="getAddrRelay2('curpostcod' , 'detail' , 'post', this.value)">
						    </select>
						    </td>
						</tr>
						<tr>
						    <td colspan="3"  id="tdcuradd2">
						    <input type="text" title="" placeholder="" class="w100p"  id="curadd2" name="curadd2"/>
						    </td>
						    <th scope="row">Postcode</th>
						    <td id="tdcurpostcod">
						    <select class="w100p" id="curpostcod" name="curpostcod">
						    </select>
						    </td>
						</tr>
						
						</tbody>
						</table><!-- table end -->
						<ul class="center_btns">
						    <li><p class="btn_blue2 big"><a id="savePopbtn"><spring:message code='sys.btn.save' /></a></p></li>
						    <li><p class="btn_blue2 big"><a id="updatePopbtn"><spring:message code='sys.btn.update' /></a></p></li>
						    <li><p class="btn_blue2 big"><a id="cancelPopbtn"><spring:message code='sys.btn.cancel' /></a></p></li>
						</ul>
					</form>
			</section>
</div>
		</section>
