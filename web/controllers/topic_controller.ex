defmodule Discuss.TopicController do
  use Discuss.Web, :controller

  alias Discuss.Topic

  def index(conn, _params) do
    topics = Repo.all(Topic)

    render conn, "index.html", topics: topics
  end

  def new(conn, _params) do
    previous_changeset = get_flash(conn, :previous_changeset)
    changeset = previous_changeset || Topic.changeset(%Topic{})

    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"topic" => topic}) do
    changeset = Topic.changeset(%Topic{}, topic)

    case Repo.insert(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic created")
        |> redirect(to: topic_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_flash(:previous_changeset, changeset)
        |> redirect(to: topic_path(conn, :new))
    end
  end

  def edit(conn, %{"id" => topic_id}) do
    previous_changeset = get_flash(conn, :previous_changeset)
    topic = Repo.get(Topic, topic_id)
    changeset = previous_changeset || Topic.changeset(topic)

    render conn, "edit.html", changeset: changeset, topic: topic
  end

  def update(conn, %{"id" => topic_id, "topic" => topic}) do
    changeset =
      Repo.get!(Topic, topic_id)
      |> Topic.changeset(topic)

    case Repo.update(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic updated")
        |> redirect(to: topic_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_flash(:previous_changeset, changeset)
        |> redirect(to: topic_path(conn, :edit, topic_id))
    end
  end

  def delete(conn, %{"id" => topic_id}) do
      Repo.get!(Topic, topic_id)
      |> Repo.delete!

      conn
      |> put_flash(:info, "Topic deleted")
      |> redirect(to: topic_path(conn, :index))
  end
end
