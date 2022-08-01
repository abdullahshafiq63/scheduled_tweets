class TweetsController < ApplicationController
  before_action :require_user_logged_in!
  before_action :set_tweet, only: [:edit, :update, :destroy]

  def index
    @tweets = Current.user.tweets
  end

  def new
    @tweet = Tweet.new
  end

  def create
    @tweet = Current.user.tweets.create(tweet_params)

    if @tweet.save
      redirect_to tweets_path, notice: "Tweet is scheduled successfully!"
    else
      render :new, status: 422
    end
  end

  def edit
  end

  def update
    if @tweet.update(tweet_params)
      redirect_to tweets_path, notice: "Tweet is Edited successfully!"
    else
      render :edit, status: 422
    end
  end

  def destroy
    @tweet.destroy
    redirect_to tweets_path, notice: "Tweet is Deleted successfully!"
  end

  private

  def tweet_params
    params.require(:tweet).permit(:twitter_account_id, :body, :publish_at)
  end

  def set_tweet
    @tweet = Current.user.tweets.find(params[:id])
  end
end