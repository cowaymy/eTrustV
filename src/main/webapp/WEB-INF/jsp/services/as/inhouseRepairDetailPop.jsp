<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">


var mode = '${mode}'; 

$(document).ready(function(){
    
    if(mode== "view"){
        $("#detailForm").find("input, textarea, button, select").attr("disabled",true);
        fn_selDetailInhouseList();
        $("#btnSaveDiv").attr("style","display:none");

    }else if (mode== "edit") {
    	 fn_selDetailInhouseList();
    }
});


function fn_selDetailInhouseList(_pram){
	
	var selectKey ;
	if( _pram =="" ){
		
		   var selectedItems = AUIGrid.getSelectedItems(inHouseRGridID);
		   selectKey = "selectKey";  //set selectedItems.key
	}
	
	Common.ajax("GET", "/services/inhouse/selInhouseDetailList.do",{asTicketNum:selectKey}, function(result) {
          console.log( result);
          
          if(result != null ){
        	  fn_setResultData(result);
          }
      });
}


function fn_doSave(){
	
	   if(mode== "edit"){
		   fn_inhouseUpDate();
	   }else if(mode== "new"){
		   fn_inhouseSave();
	   }
}

function fn_setResultData(result){
	
	$("#t1").val(result[0].t1);
	$("#t2").val(result[0].t2);
	$("#t3").val(result[0].t3);
	$("#t4").val(result[0].t4);
	$("#t5").val(result[0].t5);
	$("#t6").val(result[0].t6);
	$("#t7").val(result[0].t7);
	$("#t8").val(result[0].t8);
	$("#t9").val(result[0].t9);
	$("#t10").val(result[0].t10);
	$("#t11").val(result[0].t11);
	$("#t12").val(result[0].t12);
	$("#t13").val(result[0].t13);
	$("#t14").val(result[0].t14);
	$("#t15").val(result[0].t15);
	$("#t16").val(result[0].t16);
	$("#t17").val(result[0].t17);
	$("#t18").val(result[0].t18);
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
<form id="detailForm" method="post">

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

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:240px" />
    <col style="width:*" />
    <col style="width:200px" />
    <col style="width:*" />
    
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">In Chare of RCT </th>
    <td>
        <input title="" class="w100p" type="text" placeholder=""  id="t1"  name="t1" >
    </td>
    <th scope="row">Defect Type</th>
    <td >  
            <input title="" class="w100p" type="text" placeholder=""   id="t2"  name="t2" >
    </td>
     <th scope="row">Symptom</th>
    <td >  
            <input title="" class="w100p" type="text" placeholder=""   id="t3"  name="t3" >
    </td>
 </tr>

<tr>
    <th scope="row"> In-House Repair  Application Date </th>
    <td >
         <input type="text" title=" placeholder="DD/MM/YYYY" class="j_date" id="t4" name="t4"/>
    </td>
    
    
    <th scope="row">Promised Complete Date  </th>
    <td >
            <input type="text" title=" placeholder="DD/MM/YYYY" class="j_date" id="t5" name="t5"/>
    </td>
    <th scope="row"> </th>
    <td>
    </td>
 </tr>
<tr>
    <th scope="row">Remark </th>
    <td colspan="5"> 
        <textarea cols="10" name="t6" id="t6" rows="2" placeholder="Remark"></textarea>     
     </td>
 </tr>
</tbody>
</table><!-- table end -->


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

<ul class="center_btns mt20" id='btnSaveDiv'>
    <li><p class="btn_blue2 big"><a href="#"   onclick="fn_doSave()">Save</a></p></li>
    <li><p class="btn_blue2 big"><a href="#"    onclick="javascript:$('#detailForm').clearForm();" >Clear</a></p></li>
</ul>

</div>


</form>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
