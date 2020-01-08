package com.growingio.plugin.flutter_growingio_touch_example;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.util.Log;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.Toast;

import com.growingio.android.sdk.collection.GrowingIO;

import org.json.JSONException;
import org.json.JSONObject;

import io.flutter.app.FlutterActivity;

public class TestPageActivity extends FlutterActivity {

    private int count = 0;
    private String WELCOME_WORDS = "当前已点击图片：";
    private ImageView img = null;
    private ImageView imgg = null;
    private ImageView imggg = null;
    private ImageView imp = null;
    private ImageView impp = null;
    private LinearLayout testPageLayout = null;
    private SpHelper mSpHelper;
    private String IMG_OPEN_CNT = "imgOpenCnt";
    private int INDEX = 0;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mSpHelper = new SpHelper(this);

        Intent intent = getIntent();
        Bundle bundle = intent.getExtras();
        String toastStr = "";
        if (bundle == null) {
            toastStr = "没有携带参数";
        } else {
            for (String key : bundle.keySet()) {
                toastStr = toastStr + key + " = " + bundle.getString(key) + "; ";
            }
        }
        showToast(toastStr,800);


        final JSONObject visitor = new JSONObject();
        setContentView(R.layout.activity_test_page);
        GrowingIO.getInstance().track("TestPageOpen");

        testPageLayout =  findViewById(R.id.test_page);
        img =  findViewById(R.id.img);
        imgg =  findViewById(R.id.imgg);
        imggg =  findViewById(R.id.imggg);
        imp =  findViewById(R.id.imp);
        impp =  findViewById(R.id.impp);

//        图片点击
        img.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                count += 1;
                mSpHelper.saveImgOpenCnt(count);
                setTextandImg(mSpHelper,img,0);
                try {
                    visitor.put(IMG_OPEN_CNT,mSpHelper.getImgOpenCnt());
                    //更新登录用户属性--触达图片点击次数
                    GrowingIO.getInstance().setPeopleVariable(IMG_OPEN_CNT,mSpHelper.getImgOpenCnt());
                    //更新访问用户属性--触达图片点击次数
                    GrowingIO.getInstance().setVisitor(visitor);
                    //更新GTouch-touch1事件的「触达图片点击次数」维度的纬度值
                    GrowingIO.getInstance().track("impOpen",visitor);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
        });

//        闯关关卡数
        imgg.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                count += 1;
                mSpHelper.saveImgOpenCnt(count);
                setTextandImg(mSpHelper,imgg,1);
                try {
                    visitor.put("round_num",count);
                    //更新登录用户属性--触达图片点击次数
//                    GrowingIO.getInstance().setPeopleVariable(IMG_OPEN_CNT,mSpHelper.getImgOpenCnt());
//                    更新访问用户属性--触达图片点击次数
//                    GrowingIO.getInstance().setVisitor(visitor);
                    //更新GTouch-touch1事件的「触达图片点击次数」维度的纬度值
                    GrowingIO.getInstance().track("WinSuccess",visitor);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
        });

// 生成订单，楼层数
        imggg.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                count += 1;
                mSpHelper.saveImgOpenCnt(count);
                setTextandImg(mSpHelper,imggg,2);
                try {
                    visitor.put("floor_var",mSpHelper.getImgOpenCnt());
                    //更新登录用户属性--触达图片点击次数
//                    GrowingIO.getInstance().setPeopleVariable(IMG_OPEN_CNT,mSpHelper.getImgOpenCnt());
                    //更新访问用户属性--触达图片点击次数
//                    GrowingIO.getInstance().setVisitor(visitor);
                    //更新GTouch-touch1事件的「触达图片点击次数」维度的纬度值
                        GrowingIO.getInstance().track("payOrder",visitor);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
        });

        //   支付订单成功   支付金额总数
        imp.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                count += 1;
                mSpHelper.saveImgOpenCnt(count);
                setTextandImg(mSpHelper,imp,3);
                try {
                    visitor.put("payAmount_var","9.999999999");
                    //更新登录用户属性--触达图片点击次数
//                    GrowingIO.getInstance().setPeopleVariable(IMG_OPEN_CNT,mSpHelper.getImgOpenCnt());
                    //更新访问用户属性--触达图片点击次数
//                    GrowingIO.getInstance().setVisitor(visitor);
                    //更新GTouch-touch1事件的「触达图片点击次数」维度的纬度值
                        GrowingIO.getInstance().track("payOrderSuccess",visitor);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
        });


// touch1
        impp.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                count += 1;
                mSpHelper.saveImgOpenCnt(count);
                setTextandImg(mSpHelper,impp,4);
                try {
                    visitor.put("payAmount_var","9.999999999");
                    //更新登录用户属性--触达图片点击次数
//                    GrowingIO.getInstance().setPeopleVariable(IMG_OPEN_CNT,mSpHelper.getImgOpenCnt());
                    //更新访问用户属性--触达图片点击次数
//                    GrowingIO.getInstance().setVisitor(visitor);
                    //更新GTouch-touch1事件的「触达图片点击次数」维度的纬度值
                        GrowingIO.getInstance().track("touch1",visitor);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
        });
    }


    private void setTextandImg(SpHelper mSpHelper, ImageView img, int index) {
        if(index != INDEX){
            INDEX = index;
            count = 1;
            mSpHelper.saveImgOpenCnt(count);
        }
        int cnt = mSpHelper.getImgOpenCnt();
        StringBuilder POINT_NUM = new StringBuilder(WELCOME_WORDS).append(cnt).append("次");
        showToast(POINT_NUM.toString(),500);

        img.setImageResource(1 == cnt % 2 ? R.mipmap.u1 : R.mipmap.u2);
        Log.i(IMG_OPEN_CNT, POINT_NUM.toString());
    }


    public void showToast(final String word, final long time){
        this.runOnUiThread(new Runnable() {
            public void run() {
                final Toast toast = Toast.makeText(TestPageActivity.this, word, Toast.LENGTH_LONG);
                toast.show();
                Handler handler = new Handler();
                handler.postDelayed(new Runnable() {
                    public void run() {
                        toast.cancel();
                    }
                }, time);
            }
        });
    }
}