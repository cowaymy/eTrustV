<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">


var mode = '${mode}'; 

$(document).ready(function(){
    createAUIGrid();
    
    fn_selDetailInhouseList();
    
    if(mode== "view"){
         $("#detailForm").find("input, textarea, button, select").attr("disabled",true);
         $("#btnSaveDiv").attr("style","display:none");
         fn_asResult_viewPageContral();

    }else if (mode== "edit") {
         
    }else if (mode== "new") {

    }
    
    
});

var  regGridID;

function createAUIGrid() {
    
    var columnLayout = [
                        {dataField : "callRem",     headerText  : "Remark" ,editable       : false  } ,
                        { dataField : "c2", headerText  : "KeyBy",  width  : 80 , editable       : false},
                        { dataField : "callCrtDt", headerText  : "KeyAt ",  width  : 120  ,dataType : "date", formatString : "dd/mm/yyyy" }
                     
   ];   
   
    
    var gridPros = { usePaging : true,  pageRowCount: 20, editable: true, fixedColumnCount : 1, selectionMode : "singleRow",  showRowNumColumn : true};  
    regGridID= GridCommon.createAUIGrid("reg_grid_wrap", columnLayout  ,"" ,gridPros);
}
   
   

function fn_getCallLog(){
    Common.ajax("GET", "/services/as/getCallLog", {TYPE_ID : 'TYPE_ID'  , AS_ID:'AS_ID'}, function(result) {
        console.log("fn_getCallLog.");
        console.log( result);
        AUIGrid.setGridData(regGridID, result);
    });
}
   
   

var  sel_0104dObj={};

function fn_selDetailInhouseList(_pram){
    
    var selectKey ;
    if( _pram =="" ){
    }
    
    
    var selectedItems = AUIGrid.getSelectedItems(inHouseRGridID);
    console.log( selectedItems);
    selectKey =selectedItems[0].item.rasAsId;  //set selectedItems.keyRAS_AS_ID  AS404583
    
    Common.ajax("GET", "/services/inhouse/selInhouseDetailList.do",{AS_ID:selectKey}, function(result) {
          console.log( result);
          
          if(result != null ){ 
        	  asDataInfo = result;
        	  
        	   var options ={  
        	            AS_ID : result[0].asId,  
        	            AS_SO_ID:result[0].asSoId,   
        	            AS_RESULT_ID:result[0].asResultId,
        	            AS_RESULT_NO:result[0].asResultNo ,   
        	            MOD: mode
        	  }; 

        	  fn_setASDataInit(options);
        	  fn_asResult_editPageContral("INHOUSE");
        	  fn_setResultData(result); 
          }
      });
}



var asDataInfo={};






function fn_doSave(){
    
       if(mode== "edit"){
           fn_inhouseUpDate();
       }else if(mode== "new"){
           fn_inhouseSave();
       }
}

function fn_setResultData(result){
    
	
	if(result != null){
		
		$("#custId").val(result[0].custId);
		$("#asOpenOrdNo").val(result[0].salesOrdNo);
		$("#asOrdNo").val(result[0].salesOrdNo);
		
	}
}


function fn_inhouseUpDate(){
    
    var  updateForm ={
            "t1":$("#t1").val(),
            "t2":$("#t2").val(),
            "t3":$("#t3").val(),
            "t4":$("#t4").val(),
            "t5":$("#t5").val(),
            "t6":$("#t6").val(),
            "t7":$("#t7").val(),
            "t8":$("#t8").val(),
            "t9":$("#t9").val(),
            "t10":$("#t10").val(),
            "t11":$("#t11").val(),
            "t12":$("#t12").val(),
            "t13":$("#t13").val(),
            "t14":$("#t14").val(),
            "t15":$("#t15").val(),
            "t16":$("#t16").val(),
            "t17":$("#t17").val(),
            "t18":$("#t18").val()
    }
    
    Common.ajax("GET", "/services/inhouse/update.do",updateForm, function(result) {
        console.log("data : " + result);
        
        if(result !=null ){
            //fn_setResultData(result);
        }
    });
}




function fn_inhouseSave(){
    
    if(! fn_saveVaild()){
        Common.alert("<binvaild</b>");
        return ;
    }
    
    var  saveForm ={
            "t1":$("#t1").val(),
            "t2":$("#t2").val(),
            "t3":$("#t3").val(),
            "t4":$("#t4").val(),
            "t5":$("#t5").val(),
            "t6":$("#t6").val(),
            "t7":$("#t7").val(),
            "t8":$("#t8").val(),
            "t9":$("#t9").val(),
            "t10":$("#t10").val(),
            "t11":$("#t11").val(),
            "t12":$("#t12").val(),
            "t13":$("#t13").val(),
            "t14":$("#t14").val(),
            "t15":$("#t15").val(),
            "t16":$("#t16").val(),
            "t17":$("#t17").val(),
            "t18":$("#t18").val()
    }
    
    Common.ajax("GET", "/services/inhouse/save.do",saveForm, function(result) {
        console.log("data : " + result);
        
        if(result !=null ){
            //fn_setResultData(result);
        }
    });
}


function fn_saveVaild(){


    return true;
}




$.fn.clearForm = function() {
    return this.each(function() {
        var type = this.type, tag = this.tagName.toLowerCase();
        if (tag === 'form'){
            return $(':input',this).clearForm();
        }
        if (type === 'text' || type === 'password' || type === 'hidden' || tag === 'textarea'){
            this.value = '';
        }else if (type === 'checkbox' || type === 'radio'){
            this.checked = false;
        }else if (tag === 'select'){
            this.selectedIndex = -1;
        }
    });
};

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->


<header class="pop_header"><!-- pop_header start -->
<h1>In House Repair Progress Detail</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->
<h2>General</h2>
</aside><!-- title_line end -->

<form id="detailForm" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:240px" />
    <col style="width:*" />
    <col style="width:200px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Customer ID</th>
    <td>
        <input title="" class="readonly w100p" type="text" placeholder=""  id="custId"  disabled="disabled"  name="custId"  readonly>
    </td>
    <th scope="row">Order No</th>
    <td >  
            <input title="" class="readonly w100p" type="text" placeholder="" disabled="disabled"    id="asOrdNo"  name="asOrdNo" >
    </td>
 </tr>


<tr>
    <th scope="row"> Open AS Order No </th>
    <td >
         <input type="text" title="" placeholder="Open AS Order No "  disabled="disabled"  class="readonly" id="asOpenOrdNo" name="asOpenOrdNo"/>
    </td>
    <th scope="row">Close AS Order No </th>
    <td >
            <input type="text" title="" placeholder="Close AS Order No"disabled="disabled"  class="readonly" id="t5" name="t5"/>
    </td>
 </tr>
 
 
<tr>
    <th scope="row"> In-House Repair  Application Date </th>
    <td >
         <input type="text" title="" placeholder="DD/MM/YYYY"  disabled="disabled" class="readonly j_date" id="t4" name="t4"/>
    </td>
    <th scope="row">In-House Repair Completion Date </th>
    <td >
            <input type="text" title="" placeholder="DD/MM/YYYY" disabled="disabled"  class="readonly j_date" id="t5" name="t5"/>
    </td>
 </tr>
<tr>
    <th scope="row">Remark </th>
    <td colspan="3"> 
        <textarea cols="10" name="t6" id="t6" rows="2" placeholder="Remark"></textarea>     
     </td>
 </tr>
 
 
<tr>
    <th scope="row"> Call Log Status </th>
    <td >
         <input type="text" title="" placeholder="" class="" id="t4" name="t4"/>
    </td>
    <th scope="row">Appointment Date </th>
    <td >
            <input type="text" title="" placeholder="DD/MM/YYYY" class="j_date" id="appntDt" name="appntDt"/>
    </td>
 </tr>
 
 
</tbody>
</table><!-- table end -->
</form>
<%-- 
<aside class="title_line"><!-- title_line start -->
<h2>Progress</h2>
</aside><!-- title_line end -->




<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:240px" />
    <col style="width:*" />
    <col style="width:200px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Beginning of Repair Date </th>
    <td>
       <input type="text" title=""  placeholder="DD/MM/YYYY" class="j_date" id="t7" name="t7"/>
    </td>
    <th scope="row">End of Repair Date</th>
    <td >  
            <input type="text" title="" placeholder="DD/MM/YYYY" class="j_date" id="t8" name="t8"/>
    </td>
 </tr>

<tr>
    <th scope="row">Beginning of Inspection Date</th>
    <td >  
            <input type="text" title=""  placeholder="DD/MM/YYYY" class="j_date" id="t9" name="t9"/>
    </td>  
    
    <th scope="row"> End of Inspection Date </th>
    <td >
        <input type="text" title=""  placeholder="DD/MM/YYYY" class="j_date" id="t10" name="t10"/>
    </td>
 </tr>


<tr>
    <th scope="row">Customer Call Date</th>
    <td >  
           <input type="text" title=""  placeholder="DD/MM/YYYY" class="j_date" id="t11" name="t11"/>
    </td>
    
    <th scope="row"> Re-Install Promised Date </th>
    <td >
       <input type="text" title="" placeholder="DD/MM/YYYY" class="j_date" id="t12" name="t12"/>
    </td>
 </tr>

</tbody>
</table><!-- table end -->
   --%>


<aside class="title_line"><!-- title_line start -->
<h2>AS Call-Log Transaction</h2>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
      <div id="reg_grid_wrap" style="width:100%; height:150px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->
      
      
<!-- asResultInfo info tab  start...-->
<%-- <jsp:include page ='/services/as/asResultInfo.do'/>  --%> 
<!-- asResultInfo info tab  end...-->  
      
  
<%-- 
<aside class="title_line"><!-- title_line start -->
<h2>Usage</h2>
</aside><!-- title_line end -->



<div class="divine_auto"><!-- divine_auto start -->


<div style="width: 50%;">
        <div class="border_box" style="height:150px"><!-- border_box start -->
        
        
<aside class="title_line"><!-- title_line start -->
<h2>Usage Parts</h2>
</aside>

                <table class="type1"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:120px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                <tr>
                    <th scope="row">TBD</th>
                    <td>
                        <input title="" class="w100p" type="text" placeholder=""   id="t13"  name="t13" >
                    </td>
                 </tr>
                
                <tr>
                    <th scope="row">TBD</th>
                    <td >  
                            <input title="" class="w100p" type="text" placeholder=""   id="t14"  name="t14" >
                    </td>
                 </tr>
                 
                <tr>
                    <th scope="row">TBD</th>
                    <td >  
                            <input title="" class="w100p" type="text" placeholder=""   id="t15"  name="t15" >
                    </td>
                 </tr>
                </tbody>
                </table><!-- table end -->
        </div><!-- border_box end -->
</div>
<div style="width:50%;">
        <div class="border_box" style="height:150px; width: 450px"><!-- border_box start -->
        
           <aside class="title_line"><!-- title_line start -->
            <h2>Usage Filter</h2>
            </aside><!-- title_line end -->
            
        
            <table class="type1"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:120px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                <tr>
                    <th scope="row">TBD</th>
                    <td>
                        <input title="" class="w100p" type="text" placeholder=""   id="t16"  name=t16"" >
                    </td>
                 </tr>
                
                <tr>
                    <th scope="row">TBD</th>
                    <td >  
                            <input title="" class="w100p" type="text" placeholder=""   id="t17"  name="t17" >
                    </td>
                 </tr>
                 
                <tr>
                    <th scope="row">TBD</th>
                    <td >  
                            <input title="" class="w100p" type="text" placeholder=""   id="t18"  name="t18" >
                    </td>
                 </tr>
                </tbody>
                </table><!-- table end -->
        
        </div><!-- border_box end -->
</div>

</div>
--%>
<ul class="center_btns mt20" id='btnSaveDiv'>
    <li><p class="btn_blue2 big"><a href="#"   onclick="fn_doSave()">Save</a></p></li>
    <li><p class="btn_blue2 big"><a href="#"    onclick="javascript:$('#detailForm').clearForm();" >Clear</a></p></li>
</ul>

</div>


</form>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->

<script> 


  

</script>
